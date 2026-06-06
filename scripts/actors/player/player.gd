extends Actor

@onready var animated_sprite_2d: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var t_hurt: Timer = $Timers/HurtCooldown
@onready var a_add_health: AudioStreamPlayer2D = $Audio/AudioAddHealth
@onready var a_walk: AudioStreamPlayer2D = $Audio/AudioWalk


func _ready() -> void:
	add_to_group("player")
	health.damaged.connect(_on_damaged)
	t_hurt.timeout.connect(Callable(col_hurt, "set_deferred").bind("disabled", false))


func _physics_process(_delta: float) -> void:
	if health.IsDead():
		velocity = Vector2.ZERO
		set_physics_process(false)
		return

	if !is_attacking:
		Motion()


func Motion() -> void:
	var horizontal_move: float = Input.get_axis("ui_left", "ui_right")
	var vertical_move: float = Input.get_axis("ui_up", "ui_down")
	UpdateFlip(horizontal_move)
	velocity = Vector2(horizontal_move, vertical_move) * speed
	move_and_slide()

func AddHealth(amount: int) -> void:
	health.Heal(amount)
	a_add_health.play()

func _on_damaged(_amount: int) -> void:
	if t_hurt.is_stopped():
		t_hurt.start()
		fms.ChangeState("Hurt")

func PlayDamageFeedback() -> void:
	var tween: Tween = create_tween()

	animated_sprite_2d.material.set_shader_parameter("damage_amount", 1.0)

	tween.tween_method(
		func(value: float) -> void:
			animated_sprite_2d.material.set_shader_parameter("damage_amount", value),
		1.0,
		0.0,
		1
	)

	#return tween.finished
