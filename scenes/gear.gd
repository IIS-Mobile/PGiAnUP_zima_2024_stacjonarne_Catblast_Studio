extends Node2D
class_name Gear

const scene = preload("res://scenes/gear.tscn")
static var speed := 0.0
static var count := 0
@onready var index := count

static func create() -> Gear:
	var gear = scene.instantiate()
	return gear

func _ready() -> void:
	$ResourcePopup.hide()
	count += 1

func _physics_process(_delta: float) -> void:
	var deg = $Sprite.rotation_degrees + (speed * speed * 30.0 / (pow(2, index)))
	if deg >= 360:
		deg -= 360
		handle_resource_popup()
		get_parent().emit_signal("rotation_completed", index)
	$Sprite.rotation_degrees = deg

func handle_resource_popup():
	$ResourcePopup.show()
	$ResourcePopup.animation_player.stop()
	$ResourcePopup.animation_player.play("popup")
