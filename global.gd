extends Node

signal rotation_completed(index:int)
signal tap_performed()
signal release_steam()

const MAX_GEARS = 80
const GEARS_PER_ROW = 4
const TIERS_AMOUNT = GEARS_PER_ROW*2
const SLOWDOWN_FACTOR = 0.005
const ROTATION_ANGLE = 30
const IDLE_SPEED = 0.1
const STEAM_LIMIT = 400

var taps_count = 0
var idle = true
var phases := []
var speed := 0.0
var buffer := 0.0
var count := 0


func _ready() -> void:
	# init phases if no save state available
	phases.resize(MAX_GEARS)
	phases.fill(0.0)

var resource_names = ["tin", "copper", "brass", "bronze", "iron", "steel", "gold", "lead", "tungsten", "electrum"]
var resources = {
	str(resource_names[0]) : [0, 0, 0, 0, 0, 0, 0, 0], #indexes from 0 to 7 are the tiers
	str(resource_names[1]) : [0, 0, 0, 0, 0, 0, 0, 0],
	str(resource_names[2]) : [0, 0, 0, 0, 0, 0, 0, 0],
	str(resource_names[3]) : [0, 0, 0, 0, 0, 0, 0, 0],
	str(resource_names[4]) : [0, 0, 0, 0, 0, 0, 0, 0],
	str(resource_names[5]) : [0, 0, 0, 0, 0, 0, 0, 0],
	str(resource_names[6]) : [0, 0, 0, 0, 0, 0, 0, 0],
	str(resource_names[7]) : [0, 0, 0, 0, 0, 0, 0, 0],
	str(resource_names[8]) : [0, 0, 0, 0, 0, 0, 0, 0],
	str(resource_names[9]) : [0, 0, 0, 0, 0, 0, 0, 0]
}
var current_top_tiers = [0,0,0,0,0,0,0,0,0,0]
var current_top_resource = 0



func gcd(a: float, b: float) -> float:
	if(b == 0.0):
		return a
	return gcd(b, fmod(a, b))

func lcm(a: float, b: float) -> float:
	return (a / gcd(a, b)) * b


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
