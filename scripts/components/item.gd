extends Area2D
class_name ItemComponent

@onready var item: AnimatedSprite2D = $MeatResource
@onready var col_item: CollisionShape2D = $CollisionShape2D
@onready var part_vfx: CPUParticles2D = $MeatResource/CPUParticles2D
@onready var label: Label = $MeatResource/Label


@export var heal_amount: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player") or !body.has_method("AddHealth"):
		return
	body.AddHealth(heal_amount)
	item.texture_filter = TEXTURE_FILTER_PARENT_NODE
	col_item.set_deferred("disabled",true)
	part_vfx.set_deferred("visible",false)
	label.set_deferred("visible",false)
	item.play("pick")


func _on_meat_resource_animation_finished() -> void:
	if item.animation == "pick":
		queue_free()
