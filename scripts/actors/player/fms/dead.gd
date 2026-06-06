extends Estados

func Enter() -> void:
	GameEvents.player_died.emit()
	owner.a_dead.play()
	owner.a_walk.stop()
	anim.play("dead")
	owner.animated_sprite_2d.texture_filter = 0
	owner.animated_sprite_2d.scale = Vector2(2, 2)
	get_parent().ThisActive(false)
	owner.t_hurt.stop()
	owner.col_hurt.set_deferred("disabled",true)
	owner.col_hitbox.set_deferred("disabled",true)
	owner.col_actor.set_deferred("disabled",true)


func Update(_delta: float) -> void:
	pass
