extends Node


signal player_died()

signal camera_shake_requested(intensity: float)

func EmitPlayerDied() -> void:
	player_died.emit()

func EmitCameraShakeRequested(intensity: float) -> void:
	camera_shake_requested.emit(intensity)
