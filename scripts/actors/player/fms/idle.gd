extends Estados

func Enter() -> void:
	anim.play("idle")


func Update(_delta: float) -> void:
	if owner.name == "Warrior":return

	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO:
		emit_signal("End", "Walk")
		return

	if Input.is_action_just_pressed("attack"): #(Letra E)
		emit_signal("End", "Attack")
