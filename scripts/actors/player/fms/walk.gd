extends Estados

func Enter() -> void:
	anim.play("walk")
	owner.a_walk.play()

func Update(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction == Vector2.ZERO:
		Resume("Idle")
		return

	if Input.is_action_just_pressed("attack"):
		Resume("Attack")

func Resume(state:String):
	emit_signal("End", state)
	owner.a_walk.stop()
