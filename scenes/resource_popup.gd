extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var icon = $TextureRect
@onready var amount_label = $Label

func _on_ready():
	hide()
	icon.texture = preload("res://assets/icon.svg")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.stop()
	hide()
