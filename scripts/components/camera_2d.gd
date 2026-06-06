extends Camera2D

@export var max_offset:float = 20.0
@export var decay_speed:float = 8.0

var shake_strength:float = 0.0
var noise:FastNoiseLite = FastNoiseLite.new()
var noise_time:float = 0.0

func _ready():
	noise.seed = randi()
	GameEvents.camera_shake_requested.connect(_on_camera_shake_requested)


func _physics_process(delta: float) -> void:
	if shake_strength <= 0.0:
		offset = Vector2.ZERO
		return

	noise_time += delta * 30.0

	offset.x = noise.get_noise_1d(noise_time) * shake_strength * max_offset
	offset.y = noise.get_noise_1d(noise_time + 100.0) * shake_strength * max_offset

	shake_strength = move_toward(shake_strength, 0.0, decay_speed * delta)

func _on_camera_shake_requested(force: float):
	shake_strength = max(shake_strength, force)
