extends CanvasLayer


@onready var top_resource_areas = [
	$VBoxContainer/ColorRect/ResourceTop2,
	$VBoxContainer/ColorRect/ResourceTop1,
	$VBoxContainer/ColorRect/ResourceTop0
]


@onready var resource_areas = [
	$ResourcePopUp/Resource0,
	$ResourcePopUp/Resource1,
	$ResourcePopUp/Resource2,
	$ResourcePopUp/Resource3,
	$ResourcePopUp/Resource4,
	$ResourcePopUp/Resource5,
	$ResourcePopUp/Resource6,
	$ResourcePopUp/Resource7,
	$ResourcePopUp/Resource8,
	$ResourcePopUp/Resource9
]

@onready var tier_areas = [
	$TierPopUp/Tier0,
	$TierPopUp/Tier1,
	$TierPopUp/Tier2,
	$TierPopUp/Tier3,
	$TierPopUp/Tier4,
	$TierPopUp/Tier5,
	$TierPopUp/Tier6,
	$TierPopUp/Tier7
]

@onready var resources_pop_up = $ResourcePopUp
@onready var resources_pop_up_area = $ResourcePopUp/GoldenRect
@onready var tier_pop_up = $TierPopUp
@onready var tier_pop_up_area = $TierPopUp/GoldenRect

@onready var premium_resource_area = $VBoxContainer/ColorRect/ResourcePremium



var selected_resource_type = -1;

func update_top_resource_labels():
	
	var premium_resource_label = premium_resource_area.get_node("Label_resource")
	var premium_resource_sprite = premium_resource_area.get_node("Sprite2D")
	
	premium_resource_label.text = str(Global.premium_resource)
	premium_resource_sprite.texture = load("res://assets/art/resources/crystaline_bolts.png") 
	
	var local_current_top_resource = Global.current_top_resource
	if (local_current_top_resource < 2):
		local_current_top_resource = 2

	
	
	for i in range(2, -1, -1):
		if local_current_top_resource - i <= Global.current_top_resource:
			var top_tier = Global.current_top_tiers[local_current_top_resource - i]
			var resource_name = Global.resource_names[local_current_top_resource - i]
			var tier1_value :Big = Global.resources[resource_name][top_tier]
			var label = top_resource_areas[i].get_node("Label_resource")
			var sprite = top_resource_areas[i].get_node("Sprite2D")
			
			sprite.texture = load("res://assets/art/resources/" + str(local_current_top_resource - i +1) + "_" + str(resource_name) + "/" + str(resource_name) + "_T" + str(top_tier +1) + ".png")
			label.text = tier1_value.toAA(false,true,false)
		else:
			var label = top_resource_areas[i].get_node("Label_resource")
			var sprite = top_resource_areas[i].get_node("Sprite2D")
			label.text = str(0)
			sprite.texture = load("res://assets/art/resources/hidden_resource.png")

func update_resource_labels():

	for i in Global.current_top_resource+1:
		if i <= Global.current_top_resource:
			var top_tier = Global.current_top_tiers[i]
			var resource_name = Global.resource_names[i]
			var tier1_value : Big = Global.resources[resource_name][top_tier]
			var label = resource_areas[i].get_node("Label_resource")
			var sprite = resource_areas[i].get_node("Sprite2D")
			
			sprite.texture = load("res://assets/art/resources/" + str(i +1) + "_" + str(resource_name) + "/" + str(resource_name) + "_T" + str(top_tier +1) + ".png")
			label.text = tier1_value.toAA()

		else:
			var label = resource_areas[i].get_node("Label_resource")
			var sprite = resource_areas[i].get_node("Sprite2D")
			label.text = str(0)
			sprite.texture = load("res://assets/art/resources/hidden_resource.png")
			
func update_tier_labels():
	if selected_resource_type > Global.current_top_resource:
		tier_pop_up.visible = false
		return
	
	var resource_name = Global.resource_names[selected_resource_type]
	var top_tier = Global.current_top_tiers[selected_resource_type]
	
	for i in range(tier_areas.size()):
		if i <= top_tier:
			var tier_i_value : Big = Global.resources[resource_name][i]
			var label = tier_areas[i].get_node("Label_resource")
			var sprite = tier_areas[i].get_node("Sprite2D")
			
			label.text = tier_i_value.toAA()
			sprite.texture = load("res://assets/art/resources/" + str(selected_resource_type +1) + "_" + str(resource_name) + "/" + str(resource_name) + "_T" + str(i +1) + ".png")
		else:
			var label = tier_areas[i].get_node("Label_resource")
			var sprite = tier_areas[i].get_node("Sprite2D")
			label.text = str(0)
			sprite.texture = load("res://assets/art/resources/hidden_resource.png")
		


func _ready():
	resources_pop_up.visible = false
	$"BuyPop-up".visible = false  
	tier_pop_up.visible = false
	set_process_input(true)
	
func _process(delta):
	update_top_resource_labels()
	if resources_pop_up.visible:
		update_resource_labels()
	if tier_pop_up.visible:
		update_tier_labels()
		

func _input(event):
	if not $"/root/Node2D/UI".visible:
		return
	if event is InputEventMouseButton and event.pressed:
		var clicked_on_top_resource_rect = false
		var clicked_on_resource_rect = false
		var y_of_clicked_on_resource_rect = -90
		var clicked_on_premium_area = false 
		var clicked_on_buy_area_exit_button = false 


		if !resources_pop_up.visible:
			for top_resource_area in top_resource_areas:
				if top_resource_area.get_global_rect().has_point(event.global_position):
					clicked_on_top_resource_rect = true
					$"/root/Node2D/UISound".play()
					break
		else:
			for resource_area in resource_areas:
				if resource_area.get_global_rect().has_point(event.global_position):
					y_of_clicked_on_resource_rect = resource_area.global_position.y
					clicked_on_resource_rect = true
					var node_name = resource_area.name 
					selected_resource_type = int(node_name.substr(node_name.length() - 1, 1))
					$"/root/Node2D/UISound".play()
					break

		if premium_resource_area.get_global_rect().has_point(event.global_position):
			clicked_on_premium_area = true
			$"/root/Node2D/UISound".play()
			
		if $"BuyPop-up/TextureButton".get_global_rect().has_point(event.global_position):
			clicked_on_buy_area_exit_button = true
			$"/root/Node2D/UISound".play()

		if clicked_on_resource_rect and $"BuyPop-up".visible == false:
			if selected_resource_type <= Global.current_top_resource:
				tier_pop_up.global_position.y = y_of_clicked_on_resource_rect
				tier_pop_up.visible = true
		elif clicked_on_top_resource_rect:
			resources_pop_up.visible = true
		elif clicked_on_premium_area:
			$"BuyPop-up".visible = true  
		elif clicked_on_buy_area_exit_button:
			$"BuyPop-up".visible = false  
		elif (resources_pop_up_area.get_global_rect().has_point(event.global_position) or (tier_pop_up_area.get_global_rect().has_point(event.global_position) and tier_pop_up.visible)):
			return  # Kliknięcie wewnątrz pop-upów, nic nie robimy
		elif resources_pop_up.visible or tier_pop_up.visible:
			$"/root/Node2D/UISound".play()
			resources_pop_up.visible = false
			tier_pop_up.visible = false
