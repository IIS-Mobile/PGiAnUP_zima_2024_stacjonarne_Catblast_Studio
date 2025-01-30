extends Panel

#|================================
#| Grease 1-11:			ID  0-10 |
#| Overclock 1-11: 		ID 11-21 |
#| LSC 1-10:			ID 22-31 |
#| Melting 1-10:		ID 32-41 |
#| Barter 1-9:			ID 42-50 |
#| Forges:				ID 51-60 |
#|================================

@export_category("ID")
@export var id: int

@export_category("Image")
@export var image: Texture 

@export_category("Title and Category")
@export_multiline var title: String
@export_multiline var description: String

@export_category("Cost 1")
@export var price1: float
@export_enum("tin", "copper", "brass", "bronze", "iron", 
"steel", "gold", "lead", "tungsten", "electrum") var resource1: String = "tin"
@export_range(1, 8) var tier1: int

@export_category("Cost 2")
@export var price2: float
@export_enum("tin", "copper", "brass", "bronze", "iron", 
"steel", "gold", "lead", "tungsten", "electrum") var resource2: String = "tin"
@export_range(1, 8) var tier2: int

@export_category("Cost 3")
@export var price3: float
@export_enum("tin", "copper", "brass", "bronze", "iron", 
"steel", "gold", "lead", "tungsten", "electrum") var resource3: String = "tin"
@export_range(1, 8) var tier3: int

@export_category("Premium cost")
@export var premium_price: float = -1
@export var item_type: int = -1

var resource_name_table = [resource1,resource2,resource3]
var tier_table = [tier1,tier2,tier3]

@onready var TEXTURE_RECT = $Panel/HBoxContainer4/TextureRect
#@onready var OR_STRING = $Panel/HBoxContainer/Label

@onready var PRICE_TAG1 = $Panel/VBoxContainer3/Price1
@onready var PRICE_TAG2 = $Panel/VBoxContainer3/Price2
@onready var PRICE_TAG3 = $Panel/VBoxContainer3/Price3
@onready var PREMIUM_PRICE_TAG = $Panel/MarginContainer/Button/HBoxContainer2/PremiumPrice

@onready var RESOURCE_ICON1 = $Panel/VBoxContainer2/ResourceIcon1
@onready var RESOURCE_ICON2 = $Panel/VBoxContainer2/ResourceIcon2
@onready var RESOURCE_ICON3 = $Panel/VBoxContainer2/ResourceIcon3
@onready var PREMIUM_RESOURCE_ICON = $Panel/MarginContainer/Button/HBoxContainer2/PremiumResourceIcon

@onready var TITLE_LABEL = $Panel/VBoxContainer/Title
@onready var DESCRIPTION_LABEL = $Panel/VBoxContainer/Description

@onready var price_label_table = [
	PRICE_TAG1,
	PRICE_TAG2,
	PRICE_TAG3
]
@onready var resource_pic_table = [
	RESOURCE_ICON1, 
	RESOURCE_ICON2, 
	RESOURCE_ICON3
]

func _ready():
	set_labels()
	set_image()

func _process(delta):
	pass
	
func set_image():
	TEXTURE_RECT.texture = image

func set_free():
	price_label_table[0].text = "FREE"
	RESOURCE_ICON1.visible = false
	PRICE_TAG2.visible = false
	RESOURCE_ICON2.visible = false
	PRICE_TAG3.visible = false
	RESOURCE_ICON3.visible = false
	
	
func hide_premium():
	PREMIUM_PRICE_TAG.visible = false
	#OR_STRING.visible = false
	PREMIUM_RESOURCE_ICON.visible = false
	
func hide_resource(index):
	if(index == 1):
		return
	price_label_table[index-1].visible = false
	resource_pic_table[index-1].visible = false

func set_price(index, price, resource, tier):
	if price <= 0:
		hide_resource(index)
	
	var resource_index = Global.resource_names.find(resource)
	var resource_pic_path = "res://assets/art/resources/" + str(resource_index+1) + "_" + str(resource) + "/" + str(resource) + "_T" + str(tier) +  ".png"
	var resource_pic = resource_pic_table[index-1]
	resource_pic.texture = load(resource_pic_path)

	var price_label = price_label_table[index-1]
	price_label.text = str(price)

func set_labels():
	TITLE_LABEL.text = title
	DESCRIPTION_LABEL.text = description
	if(premium_price <= 0):
		hide_premium()
	else:
		PREMIUM_PRICE_TAG.text = str(premium_price)

	if(price1 <= 0):
		set_free()
	else:
		set_price(1, price1, resource1, tier1)
		set_price(2, price2, resource2, tier2)
		set_price(3, price3, resource3, tier3)

func _on_buy_button_pressed() -> void:
	Global.buy_button_clicked.emit(id)


#|================================
#| Grease 1-11:			ID  0-10 |
#| Overclock 1-11: 		ID 11-21 |
#| LSC 1-10:			ID 22-31 |
#| Melting 1-10:		ID 32-41 |
#| Barter 1-9:			ID 42-50 |
#| Forges:				ID 51-60 |
#|================================
