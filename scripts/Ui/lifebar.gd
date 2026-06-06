extends Control

class_name HealthBar

@export var actor:NodePath
@onready var bar: TextureProgressBar = $BigBarBase/TextureProgressBar

func _ready() -> void:
	if actor == null:
		return
	await get_tree().process_frame
	var health_component:HealthComponent = get_node(actor).health
	health_component.health_changed.connect(_on_health_changed)
	_on_health_changed(health_component.current_health, health_component.max_health)

func _on_health_changed(current: int, maximum: int) -> void:
	bar.max_value = maximum
	bar.value = current
