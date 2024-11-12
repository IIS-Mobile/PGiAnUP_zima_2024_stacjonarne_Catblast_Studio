extends Node2D
@export var index: int = 0

@onready var animation_player = $AnimationPlayer
@onready var icon = $TextureRect
@onready var amount_label = $Label

func _on_ready():
	hide()
	
	#if index > 4:
		#$TextureRect.texture = load("res://assets/art/resources/2_copper/copper_T1.png")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.stop()
	hide()
