extends Node2D
class_name Gear

const scene = preload("res://scenes/gear.tscn")
#TODO: decouple from global
@onready var index := Global.count

static func create() -> Gear:
	var gear = scene.instantiate()
	return gear

func _ready() -> void:
	#TODO: react to runtime resizes?, make generic
	scale *= (get_parent().size[0] * 0.30) / 512
	$ResourcePopup.hide()
	Global.count += 1

func handle_resource_popup():
	$ResourcePopup.show()
	$ResourcePopup.animation_player.stop()
	$ResourcePopup.animation_player.play("popup")
