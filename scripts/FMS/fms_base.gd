extends Node
class_name Fms

@export_node_path("Node") var estado_inicial

var estados:Dictionary = {}
var estado_actual:Estados = null

@export var activo = true : set = ThisActive

func _ready():
	set_physics_process(activo)
	if !activo:
		return
	for t in get_children():
		estados[t.name] = t
		t.connect("End",ChangeState)
	if estado_inicial:
		estado_actual = get_node(estado_inicial)
	else:
		print("No se asigno un estado inicial para: " + owner.name)


func _physics_process(delta) -> void:
	if activo:
		estado_actual.Update(delta)

func ChangeState(nuevo_estado) -> void:
	if !activo:
		return
	estado_actual = estados[nuevo_estado]
	estado_actual.Enter()

func ThisActive(valor) -> void:
	activo = valor
	set_physics_process(valor)
	if !activo:
		estado_actual = null
