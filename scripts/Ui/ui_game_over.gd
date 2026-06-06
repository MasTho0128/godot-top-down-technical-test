extends Control

@onready var timer: Timer = $Timer

func _ready() -> void:
	GameEvents.player_died.connect(Callable(timer, "start"))

func _on_texture_button_2_pressed() -> void:
	get_tree().quit()

func _on_texture_button_pressed() -> void:
	if get_tree().reload_current_scene() == OK:
		pass

func _on_timer_timeout() -> void:
	set_deferred("visible", true)
