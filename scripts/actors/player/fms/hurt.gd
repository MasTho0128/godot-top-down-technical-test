extends Estados

const SHAKE_INTENSITY: float = 2.0


func Enter() -> void:
	owner.a_hurt.play()
	GameEvents.camera_shake_requested.emit(SHAKE_INTENSITY)
	owner.col_hurt.set_deferred("disabled",true)
	if owner.health.IsDead():
		emit_signal("End", "Dead")
		return
	owner.PlayDamageFeedback()
	emit_signal("End", "Idle")


func Update(_delta: float) -> void:
	pass
