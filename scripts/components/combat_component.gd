extends Node2D
class_name CombatComponent

var actor: Warrior
var detection_area: Area2D
var detection_shape: CollisionShape2D
var attack_area: Area2D
var leash_area: Area2D
var attack_timer: Timer
var detection_reset_timer: Timer

var target: Node2D = null
var is_target_detected: bool = false
var is_target_in_attack_range: bool = false
var is_attack_locked: bool = false
var attack_damage: int = 1


func Setup(
	owner_actor: Warrior,
	owner_detection_area: Area2D,
	owner_detection_shape: CollisionShape2D,
	owner_attack_area: Area2D,
	owner_leash_area: Area2D,
	owner_attack_timer: Timer,
	owner_detection_reset_timer: Timer,
	owner_attack_damage: int
) -> void:
	actor = owner_actor
	detection_area = owner_detection_area
	detection_shape = owner_detection_shape
	attack_area = owner_attack_area
	leash_area = owner_leash_area
	attack_timer = owner_attack_timer
	detection_reset_timer = owner_detection_reset_timer
	attack_damage = owner_attack_damage

	if attack_timer != null:
		attack_timer.one_shot = true

	if detection_area != null:
		detection_area.body_entered.connect(_on_detection_area_body_entered)
		detection_area.body_exited.connect(_on_detection_area_body_exited)

	if attack_area != null:
		attack_area.body_entered.connect(_on_attack_area_body_entered)
		attack_area.body_exited.connect(_on_attack_area_body_exited)

	if attack_timer != null:
		attack_timer.timeout.connect(_on_attack_timer_timeout)

	if detection_reset_timer != null:
		detection_reset_timer.timeout.connect(_on_detection_reset_timer_timeout)


func Chase() -> void:
	if actor == null:
		return

	if target == null or not is_instance_valid(target):
		ResetTargetAndResumePatrol()
		return

	if not is_target_detected:
		ResetTargetAndResumePatrol()
		return

	if not IsInsideLeash():
		ResetTargetAndResumePatrol()
		DisableDetectionTemporarily()
		return

	if is_target_in_attack_range:
		actor.SetState(Warrior.STATE_ATTACK)
		actor.velocity = Vector2.ZERO
		actor.move_and_slide()
		return

	var run_speed: float = actor.speed * Warrior.RUN_MULTIPLIER
	var direction: Vector2 = actor.global_position.direction_to(target.global_position)
	actor.velocity = direction * run_speed
	
	var distance_to_target: float = actor.global_position.distance_to(target.global_position)
	if distance_to_target <= actor.attack_area.global_position.distance_to(actor.global_position) + 4.0:
		actor.velocity = Vector2.ZERO
		actor.SetState(Warrior.STATE_ATTACK)
		actor.move_and_slide()
		return
	
	actor.move_and_slide()

func Attack() -> void:
	if actor == null or actor.is_dead:
		return

	if not is_target_in_attack_range:
		actor.movement_locked = false
		if is_target_detected and target != null and is_instance_valid(target):
			actor.SetState(Warrior.STATE_RUN)
		else:
			ResetTargetAndResumePatrol()
		return

	if target == null or not is_instance_valid(target):
		actor.movement_locked = false
		ResetTargetAndResumePatrol()
		return

	if is_attack_locked:
		return

	is_attack_locked = true
	actor.movement_locked = true

	if attack_timer != null:
		attack_timer.start()

	if target.has_method("TakeDamage"):
		target.call("TakeDamage", attack_damage)

func OnDeath() -> void:
	target = null
	is_target_detected = false
	is_target_in_attack_range = false
	is_attack_locked = false

	if actor != null:
		actor.movement_locked = false

	if detection_area != null:
		detection_area.monitoring = false

	if attack_area != null:
		attack_area.monitoring = false


func ResetTargetAndResumePatrol() -> void:
	target = null
	is_target_detected = false
	is_target_in_attack_range = false

	if actor == null:
		return

	actor.movement_locked = false
	actor._resume_patrol_or_idle()

func IsInsideLeash() -> bool:
	if actor == null:
		return false

	if leash_area == null:
		return true

	return leash_area.overlaps_body(actor)


func DisableDetectionTemporarily() -> void:
	if detection_reset_timer == null:
		return

	if not detection_reset_timer.is_stopped():
		return

	if detection_area != null:
		detection_area.set_deferred("monitoring", false)

	detection_reset_timer.start()


func _on_detection_area_body_entered(body: Node) -> void:
	if actor == null or actor.is_dead:
		return

	if not body.is_in_group("player"):
		return

	target = body as Node2D
	is_target_detected = true

	if is_target_in_attack_range:
		actor.SetState(Warrior.STATE_ATTACK)
	else:
		actor.SetState(Warrior.STATE_RUN)


func _on_detection_area_body_exited(body: Node) -> void:
	if body != target:
		return

	is_target_detected = false
	is_target_in_attack_range = false
	target = null

	if detection_shape != null:
		detection_shape.set_deferred("disabled", true)

	if detection_reset_timer != null:
		detection_reset_timer.start()

	if actor != null:
		actor._resume_patrol_or_idle()


func _on_attack_area_body_entered(body: Node) -> void:
	if actor == null or actor.is_dead:
		return

	if not body.is_in_group("player"):
		return

	target = body as Node2D
	is_target_detected = true
	is_target_in_attack_range = true
	actor.SetState(Warrior.STATE_ATTACK)


func _on_attack_area_body_exited(body: Node) -> void:
	if body != target:
		return

	is_target_in_attack_range = false

	if actor == null:
		return

	if is_target_detected and target != null and is_instance_valid(target) and IsInsideLeash():
		actor.SetState(Warrior.STATE_RUN)
	else:
		target = null
		actor._resume_patrol_or_idle()

func _on_attack_timer_timeout() -> void:
	is_attack_locked = false

	if actor == null or actor.is_dead:
		return

	actor.movement_locked = false

	if is_target_in_attack_range and target != null and is_instance_valid(target):
		actor.SetState(Warrior.STATE_ATTACK)
	elif is_target_detected and target != null and is_instance_valid(target) and IsInsideLeash():
		actor.SetState(Warrior.STATE_RUN)
	else:
		ResetTargetAndResumePatrol()

func _on_detection_reset_timer_timeout() -> void:
	if actor == null or actor.is_dead:
		return

	if detection_shape != null:
		detection_shape.set_deferred("disabled", false)

	if detection_area != null:
		detection_area.set_deferred("monitoring", true)
