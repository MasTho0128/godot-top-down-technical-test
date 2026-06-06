extends Node

class_name Estados

@export_node_path("AnimatedSprite2D") var animacion
var anim:AnimatedSprite2D

signal End(sig_estado)

func _ready() -> void:
	if animacion:
		anim = get_node(animacion)
	else:
		print("No tiene una animacion asignada en la FMS y por lo tanto no funcionara correctamente " + owner.name)

func Enter():
	return emit_signal("End")

func Update(delta):
	return delta

func EnterInput(evemt):
	return evemt;
