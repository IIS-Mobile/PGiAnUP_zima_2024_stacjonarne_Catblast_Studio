extends Node

signal tap_performed()
signal release_steam()
signal buy_button_clicked(ID)
signal reload_shop()
signal ad_skipped()

const MAX_GEARS = 80
const GEARS_PER_ROW = 4
const TIERS_AMOUNT = GEARS_PER_ROW * 2
const SLOWDOWN_FACTOR = 0.005
const ROTATION_ANGLE = 30

#TODO: provide sane scaling function
#base speed multiplier, unbounded
func overclock_scaling() -> float:
	return 4. * (upgrades["Overclock"] + 1.) / (max_upgrade_values["Overclock"] + 1.)

#TODO: pretty sane function?, but could it be even better?🤔
#bounded 0-1
func grease_scaling(i: int) -> float:
	return 1. / pow(i + 1., 2. * (1. - ((upgrades["Grease"] + 1.) / (max_upgrade_values["Grease"] + 2.))))

var is_melting_on = true;
var is_barter_on = true;
var current_steam_chamber_value = 0

#TODO: provide sane scaling function
#idle time in hours unbounded
func lsc_time_scaling() -> float:
	#return 0.005
	return 8 * (upgrades["LSC"] + 1.) / (max_upgrade_values["LSC"] + 1.)
	
#TODO: provide sane scaling function
#taps needed to activate idle
func lsc_tap_scaling() -> int:
	return 400. * (1. - (upgrades["LSC"] / (max_upgrade_values["LSC"] + 1.)))

#TODO: provide sane scaling function
#bounded 0-1
func lsc_speed_scaling() -> float:
	return 0.5 * (upgrades["LSC"] + 1.) / (max_upgrade_values["LSC"] + 1.)

var very_specific_iterator_in_shopping_manager = 5 # ta zmienna jest na tyle szalona ze pewnie trzeba ja bedzie zapisywac.
var taps_count = 0.0
var idle_time = 0.0
var phases := []
var speed := 0.0 # DO NOT CHANGE, SPEED DEPENDS ON speed_multiplier
var buffer := 0.0
var count := 0
var premium_resource = 2;
var resource_names = ["tin", "copper", "brass", "bronze", "iron", "steel", "gold", "lead", "tungsten", "electrum"]
var resources = {
	str(resource_names[0]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)], #indexes from 0 to 7 are the tiers
	str(resource_names[1]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)],
	str(resource_names[2]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)],
	str(resource_names[3]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)],
	str(resource_names[4]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)],
	str(resource_names[5]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)],
	str(resource_names[6]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)],
	str(resource_names[7]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)],
	str(resource_names[8]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)],
	str(resource_names[9]) : [Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0), Big.new(0)]
}
var current_top_tiers = [0,0,0,0,0,0,0,0,0,0]
var current_top_resource = 0
var upgrade_names = ["Grease", "Overclock", "LSC", "Melting", "Barter", "ForgeTin", "ForgeCopper", "ForgeBrass", "ForgeBronze", "ForgeIron", "ForgeSteel", "ForgeGold", "ForgeLead", "ForgeTungsten", "ForgeElectrum"]
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

#TODO: numbers can get quite large, investigate accuracy
func calc_idle_resources(secs: float):
	var ticks = (secs * Engine.physics_ticks_per_second) as int
	var phase_inc = overclock_scaling() * min(lsc_speed_scaling(), 1.) * min(lsc_speed_scaling(), 1.) * ROTATION_ANGLE
	for gear in range(0, count):
		var rots = (phases[gear] + phase_inc * ticks * min(grease_scaling(gear), 1.0)) / 360.0 as int
		phases[gear] = fmod(phases[gear] + phase_inc * ticks * min(grease_scaling(gear), 1.0), 360.0)
		handle_rotation(gear, rots)

func handle_rotation(index: int, rots: int):
	var resource_index = index / TIERS_AMOUNT
	var tier = index % TIERS_AMOUNT
	if upgrades[upgrade_names[5 + resource_index]] == 1:
		rots *= 2
	resources[resource_names[resource_index]][tier].plusEquals(rots)

func _physics_process(_delta: float) -> void:
	if not count:
		return
	if buffer > 0.0:
		buffer = max(buffer - SLOWDOWN_FACTOR, 0.0)
		speed = min(speed + SLOWDOWN_FACTOR, 1.0)
	else:
		speed = max(speed - SLOWDOWN_FACTOR, 0.0)
	if idle_time > 0 and speed < min(lsc_speed_scaling(), 1.):
		buffer = min(buffer + SLOWDOWN_FACTOR, min(lsc_speed_scaling(),1.))
		idle_time = max(0.0, idle_time - 1.0 / Engine.physics_ticks_per_second)
	var phase_inc = overclock_scaling() * speed * speed * ROTATION_ANGLE
	var container = get_node("/root/Node2D/UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer/Gears")
	for child in container.get_children():
		if child is Gear:
			var rots = (phases[child.index] + phase_inc * min(grease_scaling(child.index), 1.0)) / 360.0 as int
			phases[child.index] = fmod(phases[child.index] + phase_inc * min(grease_scaling(child.index), 1.0), 360.0)
			if child.index % 2 == 0:
				child.get_node("Sprite").rotation_degrees = phases[child.index]
			else:
				child.get_node("Sprite").rotation_degrees = -phases[child.index]
			if rots > 0:
				handle_rotation(child.index, rots)
				child.handle_resource_popup()
				if child.index == 0:
					$"/root/Node2D/UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer/SpinSound".play()
