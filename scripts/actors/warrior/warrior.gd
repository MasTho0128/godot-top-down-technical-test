extends Actor
class_name Warrior

const STATE_IDLE: StringName = &"idle"
const STATE_WALK: StringName = &"walk"
const STATE_RUN: StringName = &"run"
const STATE_ATTACK: StringName = &"attack"
const STATE_DEAD: StringName = &"dead"

const RUN_MULTIPLIER: float = 1.2

@export var patrol_wait_time: float = 2.0
@export var waypoint_tolerance: float = 10.0
@export var patrol_points_root: Node2D
@export var leash_area: Area2D
@export var attack_damage: int = 1

var target: Node2D = null
var current_state: StringName = STATE_IDLE
var is_dead: bool = false
var is_target_detected: bool = false
var is_target_in_attack_range: bool = false
var _attack_locked: bool = false
var movement_locked: bool = false

@onready var detection_area: Area2D = $DetectionArea
@onready var col_detec: CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var attack_area: Area2D = $AttackArea
@onready var patrol_timer: Timer = $Timers/PatrolTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var animation_player: AnimationPlayer = $AnimsP/AnimationPlayer
@onready var detec_timer: Timer = $Timers/DetecTimer

@onready var patrol_component: PatrolComponent = $PatrolComponent
@onready var combat_component: CombatComponent = $CombatComponent


func _ready() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if not players.is_empty() and players[0] is PhysicsBody2D:
		add_collision_exception_with(players[0] as PhysicsBody2D)
	patrol_component.Setup(
		self,
		patrol_timer,
		patrol_points_root,
		patrol_wait_time,
		waypoint_tolerance
	)

	combat_component.Setup(
		self,
		detection_area,
		col_detec,
		attack_area,
		leash_area,
		attack_timer,
		detec_timer,
		attack_damage
	)

	patrol_timer.wait_time = patrol_wait_time
	patrol_timer.one_shot = true
	attack_timer.one_shot = true

	health.health_depleted.connect(_on_health_depleted)
	health.damaged.connect(_on_damaged)

	patrol_timer.timeout.connect(_on_patrol_timer_timeout)

	SetState(STATE_WALK)



func _physics_process(delta: float) -> void:
	target = combat_component.target
	is_target_detected = combat_component.is_target_detected
	is_target_in_attack_range = combat_component.is_target_in_attack_range
	_attack_locked = combat_component.is_attack_locked

	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if movement_locked:
		velocity = Vector2.ZERO
		move_and_slide()
		UpdateFlip(velocity.x)
		return

	match current_state:
		STATE_IDLE:
			velocity = Vector2.ZERO
			move_and_slide()

		STATE_WALK:
			patrol_component.Patrol(delta)

		STATE_RUN:
			combat_component.Chase()

		STATE_ATTACK:
			velocity = Vector2.ZERO
			move_and_slide()
			combat_component.Attack()

		_:
			velocity = Vector2.ZERO
			move_and_slide()

	UpdateFlip(velocity.x)

func SetState(state: StringName) -> void:
	if current_state == state:
		return

	current_state = state
	PlayStateAnimation(state)


func Patrol(delta: float) -> void:
	patrol_component.Patrol(delta)


func ChaseTarget(_delta: float) -> void:
	combat_component.Chase()


func AttackTarget() -> void:
	combat_component.Attack()


func Die() -> void:
	if is_dead:
		return

	a_dead.play()
	is_dead = true
	velocity = Vector2.ZERO

	combat_component.OnDeath()

	SetState(STATE_DEAD)


func _resume_patrol_or_idle() -> void:
	if patrol_component.is_waiting_at_waypoint:
		SetState(STATE_IDLE)
	else:
		SetState(STATE_WALK)


func _on_health_depleted() -> void:
	Die()


func _on_patrol_timer_timeout() -> void:
	patrol_component.on_patrol_timer_timeout()


func PlayStateAnimation(anim_name: StringName) -> void:
	if animation_player.current_animation == String(anim_name):
		return

	animation_player.play(String(anim_name))

func _is_inside_leash() -> bool:
	if leash_area == null:
		return true

	return leash_area.overlaps_body(self)

func _on_damaged(_amount: int) -> void:
	a_hurt.play()
