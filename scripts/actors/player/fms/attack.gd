extends Estados

func Enter() -> void:
	anim.play("attack")
	owner.a_attack.play()
	owner.is_attacking = true
	owner.col_hitbox.set_deferred("disabled",false)


func Update(_delta: float) -> void:
	if not anim.is_playing():
		emit_signal("End", "Idle")
		owner.col_hitbox.set_deferred("disabled",true)
		owner.is_attacking = false
