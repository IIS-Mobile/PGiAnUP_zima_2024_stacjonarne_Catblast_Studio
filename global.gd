extends Node

signal tap_performed()
signal release_steam()
signal begin_idling(idling_time)
signal buy_button_clicked(ID)

# gauge hand rotation: -135deg to 135deg

const MAX_GEARS = 80
const GEARS_PER_ROW = 4
const TIERS_AMOUNT = GEARS_PER_ROW * 2
const SLOWDOWN_FACTOR = 0.005
const ROTATION_ANGLE = 30
const IDLE_SPEED = 0.1
const STEAM_LIMIT = 400.0

var current_steam_chamber_value = 0
var current_steam_gauge_value = 0

var taps_count = 0.0
var idle = false
var phases := []
var speed_multiplier := 1.0
var speed := 0.0 # DO NOT CHANGE, SPEED DEPENDS ON speed_multiplier
var buffer := 0.0
var count := 0

var idle_timer : Timer

func _ready() -> void:
	# init phases if no save state available
	phases.resize(MAX_GEARS)
	phases.fill(0.0)
	idle_timer = Timer.new()
	idle_timer.one_shot = true
	add_child(idle_timer)

var premium_resource = 0;
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

var upgrade_names = ["grease", "overclock", "lsc", "melting", "barter", "tin_forge", "copper_forge", "brass_forge", "bronze_forge", "iron_forge", "steel_forge", "gold_forge", "lead_forge", "tungsten_forge", "electrum_forge"]

var max_upgrade_values = {
	str(upgrade_names[0]) : 11,
	str(upgrade_names[1]) : 11,
	str(upgrade_names[2]) : 10,
	str(upgrade_names[3]) : resource_names.size(),
	str(upgrade_names[4]) : resource_names.size()-1,
	
	#forge type upgrades
	str(upgrade_names[5]) : 1,
	str(upgrade_names[6]) : 1,
	str(upgrade_names[7]) : 1,
	str(upgrade_names[8]) : 1,
	str(upgrade_names[9]) : 1,
	str(upgrade_names[10]) : 1,
	str(upgrade_names[11]) : 1,
	str(upgrade_names[12]) : 1,
	str(upgrade_names[13]) : 1,
	str(upgrade_names[14]) : 1
}

var upgrades = { #current state of upgrades
	str(upgrade_names[0]) : 0, #0 means not bought, 1 means level 1 etc.
	str(upgrade_names[1]) : 0,
	str(upgrade_names[2]) : 0,
	str(upgrade_names[3]) : 0,
	str(upgrade_names[4]) : 0,
	
		#forge type upgrades
	str(upgrade_names[5]) : 0,
	str(upgrade_names[6]) : 0,
	str(upgrade_names[7]) : 0,
	str(upgrade_names[8]) : 0,
	str(upgrade_names[9]) : 0,
	str(upgrade_names[10]) : 0,
	str(upgrade_names[11]) : 0,
	str(upgrade_names[12]) : 0,
	str(upgrade_names[13]) : 0,
	str(upgrade_names[14]) : 0
}

var  is_melting_on = false;
var  is_barter_on = false;


# function takes gear index and returns a fraction of base speed
func ratio_function(i: int) -> float:
	#return 1.0 / pow(2.0, i)
	return 1.0 / (i + 1)

#TODO: account for how long actually we can idle, numbers can get quite large, investigate accuracy
func calc_idle_resources(secs: float):
	var ticks = (secs * Engine.physics_ticks_per_second) as int
	var phase_inc = speed_multiplier * IDLE_SPEED * IDLE_SPEED * ROTATION_ANGLE
	for gear in range(0, count):
		var rots = (phases[gear] + phase_inc * ticks * min(ratio_function(gear), 1.0)) / 360.0 as int
		phases[gear] = fmod(phases[gear] + phase_inc * ticks * min(ratio_function(gear), 1.0), 360.0)
		handle_rotation(gear, rots)

func handle_rotation(index: int, rots: int):
	var resource_name = resource_names[index / TIERS_AMOUNT]
	var tier = index % TIERS_AMOUNT
	resources[resource_name][tier] += rots

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
	var phase_inc = speed_multiplier * speed * speed * ROTATION_ANGLE
	#TODO: should handle case when does not exist yet?
	var container = get_node("/root/Node2D/UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer/Gears")
	for child in container.get_children():
		if child is Gear:
			var rots = (phases[child.index] + phase_inc * min(ratio_function(child.index), 1.0)) / 360.0 as int
			phases[child.index] = fmod(phases[child.index] + phase_inc * min(ratio_function(child.index), 1.0), 360.0)
			child.get_node("Sprite").rotation_degrees = phases[child.index]
			if rots > 0:
				handle_rotation(child.index, rots)
				#TODO: display +rots instead of +1
				child.handle_resource_popup()
				if child.index == 0:
					get_node("/root/Node2D/UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer/Sound").play()
		  #not sure if they are not stacking (replace signal with function?)
					emit_signal("rotation_completed", child.index)


func handle_idling(idling_time):
	Global.idle = true
	await get_tree().create_timer(idling_time).timeout
	print("NO CIEKAWE CZY FAKTYCZNIE TYLE MINIE (jak cos to mija bo sprawdzalem)")
	Global.idle = false
