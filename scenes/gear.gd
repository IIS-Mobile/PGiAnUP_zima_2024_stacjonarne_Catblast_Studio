extends Node2D
class_name gear

static var speed := 0.0
static var count := 0
@onready var index := count
var rots := 0

func _ready() -> void:
	count += 1

func _physics_process(_delta: float) -> void:
	var deg = rotation_degrees + (speed * speed * 50.0 / (2 * (index + 1)))
	if deg >= 360:
		deg -= 360
		print("Rotation ", rots, " on gear ", index)
		if index==0:
			$Sound.play()
		rots += 1
	rotation_degrees = deg
