extends CharacterBody2D
class_name Actor

@export var speed: float = 500.0

@onready var visual: Node2D = $Visual
@onready var health: HealthComponent = $HealthComponent
@onready var col_hitbox: CollisionShape2D = $Visual/HitboxComponent/CollisionShape2D
@onready var fms: Node = $FMS
@onready var col_hurt: CollisionShape2D = $HurtboxComponent/CollisionShape2D
@onready var col_actor: CollisionShape2D = $Colision




@onready var a_attack: AudioStreamPlayer2D = $Audio/AudioAttack
@onready var a_hurt: AudioStreamPlayer2D = $Audio/AudioHurt
@onready var a_dead: AudioStreamPlayer2D = $Audio/AudioDead



var is_attacking:bool = false


func UpdateFlip(horizontal_move: float) -> void:
	if horizontal_move == 0.0:
		return
	visual.scale.x = sign(horizontal_move)
