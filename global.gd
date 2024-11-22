extends Node

signal rotation_completed(index:int)

const MAX_GEARS = 16
const GEARS_PER_ROW = 4
const TIERS_AMOUNT = GEARS_PER_ROW*2
const SLOWDOWN_FACTOR = 0.005
const ROTATION_ANGLE = 30
const IDLE_SPEED = 0.1

var idle = true
var phases := []
var speed := 0.0
var buffer := 0.0
var count := 0

func _ready() -> void:
	# init phases if no save state available
	phases.resize(MAX_GEARS)
	phases.fill(0.0)

func ratio_function(i: int) -> float:
	#return 1.0 / pow(2.0, i)
	return 0.5 / (1.2 * i + 1.0)

func _physics_process(_delta: float) -> void:
	if not count:
		return
	if buffer > 0.0:
		buffer = max(buffer - SLOWDOWN_FACTOR, 0.0)
		speed = min(speed + SLOWDOWN_FACTOR, 1.0)
	else:
		speed = max(speed - SLOWDOWN_FACTOR, 0.0)
	if idle and speed < IDLE_SPEED:
		buffer = min(buffer + SLOWDOWN_FACTOR, IDLE_SPEED)
	var phase_inc = speed * speed * ROTATION_ANGLE
	#TODO: should handle case when does not exist yet?
	var container = get_node("/root/Node2D/UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer/Gears")
	for child in container.get_children():
		if child is Gear:
			var prev_phase = phases[child.index]
			phases[child.index] = fmod(phases[child.index] + phase_inc * ratio_function(child.index), 360.0)
			child.get_node("Sprite").rotation_degrees = phases[child.index]
			if prev_phase > phases[child.index]:
				child.handle_resource_popup()
				emit_signal("rotation_completed", child.index)
