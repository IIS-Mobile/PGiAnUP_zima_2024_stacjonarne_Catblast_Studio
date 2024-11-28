extends Panel

#@export var title: String = "Title"
#@export var description: String = "Description Description"
#@export var price: float = -1
#@export var resource: String = "tin"
#@export var tier: int = -1
#@export var special_currency_price: float = -1
#@export var item_type: int = -1
#
##item types: reset = 0 add_gear = 1
#
#@onready var price_label = $VBoxContainer/HBoxContainer/Price
#var resource_index: int = -1

func _ready():
	#set_labels()
	pass


#func _process(delta):
	#pass
#
#func set_free():
	#price_label.text = "FREE"
	#$VBoxContainer/HBoxContainer/ResourceIcon.visibility = false
#func hide_premium_price():
	#$VBoxContainer/HBoxContainer/PremiumPrice.visibility = false
	#$VBoxContainer/HBoxContainer/PremiumResourceIcon.visibility = false
#
#func set_labels():
	#var title_label = $VBoxContainer/Title
	#var description_label = $VBoxContainer/Description
	#
	
	#var is_resource_name_correct = true
	#var is_tier_in_range = true
	#
	#if Global.resource_names.has(resource):
		#is_resource_name_correct = true
		#resource_index = Global.resource_names.find(resource)
	#else:
		#is_resource_name_correct = false
		#resource_index = -1 
	#
	#if(tier < 0 || tier > Global.TIERS_AMOUNT):
		#is_tier_in_range = false
	#
	#
	#if(is_resource_name_correct && is_tier_in_range):
		#var resource_pic_path = "res://assets/art/resources/" + str(resource_index+1) + "_" + str(resource) + "/" + str(resource) + "_T" + str(tier) +  ".png"
	#
#
	#if(price <= 0):
		#price_label.text = str(price)
	#
	#else:
		#set_free()
	
	
	
