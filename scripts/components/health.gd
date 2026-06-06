extends Node
class_name HealthComponent

signal damaged(amount: int)
signal healed(amount: int)
signal health_changed(current: int, maximum: int)
signal health_depleted()

@export var max_health: int = 5

var current_health: int = 0


func _ready() -> void:
	current_health = max(max_health, 1)
	health_changed.emit(current_health, max_health)


func TakeDamage(amount: int) -> void:
	if amount <= 0 or IsDead():
		return

	current_health = max(current_health - amount, 0)
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)

	if current_health == 0:
		health_depleted.emit()


func Heal(amount: int) -> void:
	if amount <= 0 or IsDead():
		return

	current_health = min(current_health + amount, max_health)
	healed.emit(amount)
	health_changed.emit(current_health, max_health)


func IsDead() -> bool:
	return current_health <= 0


func GetHealthPercent() -> float:
	if max_health <= 0:
		return 0.0

	return float(current_health) / float(max_health)
