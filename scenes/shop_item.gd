extends Panel

@export var image: Texture 

@export var title: String
@export var description: String
@export var price1: float
@export var resource1: String
@export var tier1: int

@export var price2: float
@export var resource2: String 
@export var tier2: int

@export var price3: float
@export var resource3: String
@export var tier3: int

var resource_name_table = [resource1,resource2,resource3]
var tier_table = [tier1,tier2,tier3]

@export var premium_price: float = -1
@export var item_type: int = -1

@onready var texture_rect = $Panel/TextureRect 

@onready var price_label_table = [
	$Panel/VBoxContainer/HBoxContainer/Price1,
	$Panel/VBoxContainer/HBoxContainer/Price2,
	$Panel/VBoxContainer/HBoxContainer/Price3
]
@onready var resource_pic_table = [
	$Panel/VBoxContainer/HBoxContainer/ResourceIcon1,
	$Panel/VBoxContainer/HBoxContainer/ResourceIcon2,
	$Panel/VBoxContainer/HBoxContainer/ResourceIcon3
]

func _ready():
	set_labels()
	set_image()
	pass

func _process(delta):
	pass
	
func set_image():
	texture_rect.texture = image


func set_free():
	price_label_table[0].text = "FREE "
	$Panel/VBoxContainer/HBoxContainer/ResourceIcon1.visible = false
	$Panel/VBoxContainer/HBoxContainer/Price2.visible = false
	$Panel/VBoxContainer/HBoxContainer/ResourceIcon2.visible = false
	$Panel/VBoxContainer/HBoxContainer/Price3.visible = false
	$Panel/VBoxContainer/HBoxContainer/ResourceIcon3.visible = false
	
	
func hide_premium():
	$Panel/VBoxContainer/HBoxContainer/PremiumPrice.visible = false
	$Panel/VBoxContainer/HBoxContainer/PremiumResourceIcon.visible = false
	
func hide_resource(index):
	if(index == 1):
		return
	price_label_table[index-1].visible = false
	resource_pic_table[index-1].visible = false	

func set_price(index, price, resource, tier):
	print(resource)
	var resource_index: int = -1
	
	if price <=0:
		hide_resource(index)
	
	var is_resource_name_correct = true

	
	if Global.resource_names.has(resource):
		is_resource_name_correct = true
		resource_index = Global.resource_names.find(resource)
	else:
		hide_resource(index)
		is_resource_name_correct = false
		resource_index = -1 
	
	if(tier < 0 || tier > Global.TIERS_AMOUNT):
		hide_resource(index)

		
	if(is_resource_name_correct):
		var resource_pic_path = "res://assets/art/resources/" + str(resource_index+1) + "_" + str(resource) + "/" + str(resource) + "_T" + str(tier) +  ".png"
		var resource_pic = resource_pic_table[index-1]
		resource_pic.texture = load(resource_pic_path)
		
	var price_label = price_label_table[index-1]
		
	price_label.text = str(price)

	


func set_labels():
	var title_label = $Panel/VBoxContainer/Title
	var description_label = $Panel/VBoxContainer/Description
	
	title_label.text = title;
	description_label.text = description;
	
	if(premium_price <= 0):
		hide_premium()
	else:
		var premium_resource_label = $Panel/VBoxContainer/HBoxContainer/PremiumPrice
		premium_resource_label.text = str(premium_price)

	if(price1 <= 0):
		set_free()
	else:
		set_price(1, price1, resource1, tier1)
		set_price(2, price2, resource2, tier2)
		set_price(3, price3, resource3, tier3)
