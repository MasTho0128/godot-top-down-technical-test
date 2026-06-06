extends Fms

func _ready() -> void:
	if !activo:
		return
	super()
	ThisActive(activo)
	ChangeNewStatus(estado_actual.name)

func ChangeNewStatus(nuevo_estado):
	ChangeState(nuevo_estado)
