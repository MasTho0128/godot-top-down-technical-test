extends Node2D
class_name PatrolComponent

var actor: Warrior
var patrol_timer: Timer
var patrol_points_root: Node2D

var patrol_points: Array[Node2D] = []
var patrol_index: int = 0
var patrol_wait_time: float = 2.0
var waypoint_tolerance: float = 10.0
var is_waiting_at_waypoint: bool = false


func Setup(
	owner_actor: Warrior,
	owner_patrol_timer: Timer,
	owner_patrol_points_root: Node2D,
	owner_patrol_wait_time: float,
	owner_waypoint_tolerance: float
) -> void:
	actor = owner_actor
	patrol_timer = owner_patrol_timer
	patrol_points_root = owner_patrol_points_root
	patrol_wait_time = owner_patrol_wait_time
	waypoint_tolerance = owner_waypoint_tolerance

	if patrol_timer != null:
		patrol_timer.wait_time = patrol_wait_time
		patrol_timer.one_shot = true

	_setup_patrol_points()


func _setup_patrol_points() -> void:
	patrol_points.clear()

	if patrol_points_root == null:
		return

	for child: Node in patrol_points_root.get_children():
		if child is Node2D:
			patrol_points.append(child)


func Patrol(delta: float) -> void:
	if actor == null:
		return

	if patrol_points.is_empty():
		actor.velocity = Vector2.ZERO
		actor.SetState(Warrior.STATE_IDLE)
		actor.move_and_slide()
		return

	if is_waiting_at_waypoint:
		actor.velocity = Vector2.ZERO
		actor.move_and_slide()
		return

	var waypoint: Node2D = patrol_points[patrol_index]
	if waypoint == null or not is_instance_valid(waypoint):
		actor.velocity = Vector2.ZERO
		actor.move_and_slide()
		return

	var to_waypoint: Vector2 = waypoint.global_position - actor.global_position
	var distance_to_waypoint: float = to_waypoint.length()

	if distance_to_waypoint <= waypoint_tolerance:
		actor.global_position = waypoint.global_position
		actor.velocity = Vector2.ZERO
		is_waiting_at_waypoint = true
		actor.SetState(Warrior.STATE_IDLE)

		if patrol_timer != null and patrol_timer.is_stopped():
			patrol_timer.start()

		actor.move_and_slide()
		return

	if delta <= 0.0:
		return

	var direction: Vector2 = to_waypoint.normalized()
	var move_speed: float = min(actor.speed, distance_to_waypoint / delta)
	actor.velocity = direction * move_speed
	actor.move_and_slide()


func on_patrol_timer_timeout() -> void:
	is_waiting_at_waypoint = false

	if actor == null:
		return

	if actor.is_dead:
		return

	if actor.is_target_in_attack_range and actor.target != null and is_instance_valid(actor.target):
		actor.SetState(Warrior.STATE_ATTACK)
		return

	if actor.is_target_detected and actor.target != null and is_instance_valid(actor.target) and actor._is_inside_leash():
		actor.SetState(Warrior.STATE_RUN)
		return

	if not patrol_points.is_empty():
		patrol_index = (patrol_index + 1) % patrol_points.size()

	actor.SetState(Warrior.STATE_WALK)
