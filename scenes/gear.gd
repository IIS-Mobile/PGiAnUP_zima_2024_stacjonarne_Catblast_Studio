extends Control
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
	handle_resource_indicator()

func handle_resource_popup():
	$ResourcePopup.show()
	$ResourcePopup.animation_player.stop()
	$ResourcePopup.animation_player.play("popup")
	
	
func handle_resource_indicator():
	var incremented_index = index + 1
	var materials = [
		{"name": "tin", "multiplier": 0},
		{"name": "copper", "multiplier": 1},
		{"name": "brass", "multiplier": 2},
		{"name": "bronze", "multiplier": 3},
		{"name": "iron", "multiplier": 4},
		{"name": "steel", "multiplier": 5},
		{"name": "gold", "multiplier": 6},
		{"name": "lead", "multiplier": 7},
		{"name": "tungsten", "multiplier": 8},
		{"name": "electrum", "multiplier": 9}
	]

	var tier_index = 0
	for i in range(materials.size()):
		if incremented_index > Global.TIERS_AMOUNT * materials[i]["multiplier"]:
			tier_index = i
		else:
			break

	var selected_material = materials[tier_index]
	var resource_tier = str(incremented_index - (Global.TIERS_AMOUNT * selected_material["multiplier"]))
	
	var gear_texture_node = $Sprite
	var res_texture_node = $ResourcePopup.get_node("TextureRect")
	
	var gearpic_path = "res://assets/art/gears/%d_%s/%sgear_T%s.png" % [tier_index + 1,selected_material["name"], selected_material["name"], resource_tier]
	var respic_path = "res://assets/art/resources/%d_%s/%s_T%s.png" % [tier_index + 1,selected_material["name"], selected_material["name"], resource_tier]

	gear_texture_node.texture = load(gearpic_path) 
	res_texture_node.texture = load(respic_path) 
