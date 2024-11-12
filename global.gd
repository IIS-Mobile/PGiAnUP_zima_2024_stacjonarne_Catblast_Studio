extends Node

signal rotation_completed(index:int)

const MAX_GEARS = 16
const GEARS_PER_ROW = 4
const TIERS_AMOUNT = GEARS_PER_ROW*2
const SLOWDOWN_FACTOR = 0.005
const ROTATION_ANGLE = 30
const IDLE_SPEED = 0.1

var idle = true
var speed := 0.0
var buffer := 0.0
var count := 0
var phase := 0.0
var prev_phase := 0.0

func _physics_process(_delta: float) -> void:
	if not count:
		return
	if buffer > 0.0:
		buffer = max(buffer - SLOWDOWN_FACTOR, 0.0)
		speed = min(speed + SLOWDOWN_FACTOR, 1.0)
	else:
		speed = max(speed - SLOWDOWN_FACTOR, 0.0)
	if idle and speed < IDLE_SPEED:
		#TODO: relate max to IDLE_SPEED
		buffer = min(buffer + SLOWDOWN_FACTOR, 1.0)
	prev_phase = phase
	#TODO: optimize out the angles
	phase += speed * speed * ROTATION_ANGLE
	phase = fmod(phase, 360.0 * pow(2, Global.MAX_GEARS - 1))
	#TODO: should handle case when does not exist yet?
	var container = get_node("/root/Node2D/UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer")
	for child in container.get_children():
		if child is Gear:
			var prev_deg = fmod(prev_phase / pow(2, child.index), 360.0)
			var deg = fmod(phase / pow(2, child.index), 360.0)
			child.get_node("Sprite").rotation_degrees = deg
			if deg < prev_deg:
				child.handle_resource_popup()
				emit_signal("rotation_completed", child.index)
