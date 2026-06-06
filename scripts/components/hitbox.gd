extends Area2D
class_name HitboxComponent

@export var damage: int = 1


func _ready() -> void:
	add_to_group("hitboxes")


func GetDamage() -> int:
	return damage

func GetDamageOwner() -> Node:
	return owner
