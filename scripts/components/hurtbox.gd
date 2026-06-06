extends Area2D
class_name HurtboxComponent

signal hitbox_received(hitbox: Area2D)

@export var health_component: HealthComponent



func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hitboxes"):
		return

	if not area.has_method("GetDamage"):
		return

	if area.has_method("GetDamageOwner") and area.GetDamageOwner() == owner:
		return

	hitbox_received.emit(area)

	if health_component == null:
		return

	health_component.TakeDamage(area.GetDamage())
