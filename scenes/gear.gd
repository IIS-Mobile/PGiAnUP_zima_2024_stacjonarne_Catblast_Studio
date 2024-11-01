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
	count += 1

func _physics_process(_delta: float) -> void:
	var deg = rotation_degrees + (speed * speed * 30.0 / (pow(2, index)))
	if deg >= 360:
		deg -= 360
		get_parent().emit_signal("rotation_completed", index)
	rotation_degrees = deg
