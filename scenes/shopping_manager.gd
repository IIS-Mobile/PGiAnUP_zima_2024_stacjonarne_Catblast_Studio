extends PanelContainer

var is_product_affordable = []

# ta niebotycznie nieczytelna mapa jest po to zeby tlumaczyc id od 0 do 60 na konkretny upgrade na zasadzie:
#|================================
#| Grease 1-11:			ID  0-10 |
#| Overclock 1-11: 		ID 11-21 |
#| LSC 1-10:			ID 22-31 |
#| Melting 1-10:		ID 32-41 |
#| Barter 1-9:			ID 42-50 |
#| Forges:				ID 51-60 |
#|================================
var id_to_upgrade_map: Dictionary = {
	# Grease 1-11
	0: 1,  1: 2,  2: 3,  3: 4,  4: 5,  5: 6,  6: 7,  7: 8,  8: 9,  9: 10, 10: 11,
	# Overclock 1-11
	11: 1, 12: 2, 13: 3, 14: 4, 15: 5, 16: 6, 17: 7, 18: 8, 19: 9, 20: 10, 21: 11,
	# LSC 1-10
	22: 1, 23: 2, 24: 3, 25: 4, 26: 5, 27: 6, 28: 7, 29: 8, 30: 9, 31: 10,
	# Melting 1-10
	32: 1, 33: 2, 34: 3, 35: 4, 36: 5, 37: 6, 38: 7, 39: 8, 40: 9, 41: 10,
	# Barter 1-9
	42: 1, 43: 2, 44: 3, 45: 4, 46: 5, 47: 6, 48: 7, 49: 8, 50: 9,
	# Forges
	51: 1, 52: 2, 53: 3, 54: 4, 55: 5, 56: 6, 57: 7, 58: 8, 59: 9, 60: 10
}

func _ready() -> void:
	Global.connect("buy_button_clicked", handle_buy_button)
	Global.connect("reload_shop", load_shop_items)
	is_product_affordable.resize(61)
	is_product_affordable.fill(false)
	load_shop_items()
	
func _process(delta):
	#print($ScrollContainer/VBoxContainer.get_child_count())
	for i in range($ScrollContainer/VBoxContainer.get_child_count()):
		if $ScrollContainer/VBoxContainer.get_child(i).visible:
			check_product_affordability(i)
			visual_update(i)
		
func check_product_affordability(product_index):
	var product_bar = $ScrollContainer/VBoxContainer.get_child(product_index)
	var is_affordable = true
	
	for resource_index in range(3):
		var resource_key = "resource" + str(resource_index + 1)
		var tier_key = "tier" + str(resource_index + 1)
		var price_key = "price" + str(resource_index + 1)

		var resource = Global.resources[product_bar.get(resource_key)][product_bar.get(tier_key)-1] 
																							   # ^NIE WIEM CZEMU TO -1 ALE INACZEJ NIEPOPRAWNIE DZIALA
		var price = product_bar.get(price_key)
		var price_label = product_bar.get_child(0).get_child(4).get_child(resource_index)
		
		if resource < price:
			price_label.add_theme_color_override("font_color", Color(1, 0, 0, 1))
			is_affordable = false
		else:
			price_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
			

	is_product_affordable[product_index] = is_affordable

func visual_update(product_index):
	var product_bar = $ScrollContainer/VBoxContainer.get_child(product_index)
	var buy_button = product_bar.get_child(0).get_child(5).get_child(0)
	var premium_resource = buy_button.get_child(0).get_child(0)
	var premium_label = buy_button.get_child(0).get_child(1)
	
	if is_product_affordable[product_index]:
		buy_button.text = "BUY"
		premium_resource.hide()
		premium_label.hide()
	else:
		buy_button.text = ""
		premium_resource.show()
		premium_label.show()
		if Global.premium_resource < int(premium_label.text):
			premium_label.add_theme_color_override("font_color", Color(1, 0, 0, 1))
		else:
			premium_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
			
		
func handle_buy_button(id):
	var product_bar = $ScrollContainer/VBoxContainer.get_child(id)
	var buy_button = product_bar.get_child(0).get_child(5).get_child(0)
	var premium_label = buy_button.get_child(0).get_child(1)
	
	if is_product_affordable[id]:
		for resource_index in range(3):
			var resource_key = "resource" + str(resource_index + 1)
			var tier_key = "tier" + str(resource_index + 1)
			var price_key = "price" + str(resource_index + 1)
			var resource = Global.resources[product_bar.get(resource_key)][product_bar.get(tier_key)-1] #to ile mam surowca
			
			Global.resources[product_bar.get(resource_key)][product_bar.get(tier_key)-1] -= product_bar.get(price_key)
			
		product_bar.visible = false
		successful_purchase(id)
		
	elif Global.premium_resource > int(premium_label.text):
		Global.premium_resource -= int(premium_label.text)
		product_bar.visible = false
		print("KOŁ?!")
		successful_purchase(id)
	else:
		Global.not_enough_premium_currency.emit()

func successful_purchase(id):
	var index = -1
	
	if id >=0 and id <= 10:
		index = 0
	elif id >= 11 and id <= 21:
		index = 1
	elif id >= 22 and id <= 31:
		index = 2
	elif id >= 32 and id <= 41:
		index = 3
	elif id >= 42 and id <= 50:
		index = 4
	elif id >= 51 and id <= 60:
		index = id - 46 # OSTROŻNIE !!!!
	
	if index == -1:
		print("ALARM - indeks wyniósł -1 zamiast od 0 do 60")
	else:
		Global.upgrades[Global.upgrade_names[index]] = id_to_upgrade_map[id]
		load_shop_items()

#func load_shop_items():
	#pass

func load_shop_items():
	# Grease, Overclock, Larger Steam Chamber, Melting
	for i in range(4):
		var upgrade_name = Global.upgrade_names[i]
		var upgrade_level = Global.upgrades[upgrade_name]
		var upgrade = upgrade_name + str(upgrade_level + 1)
		var prodbar = $ScrollContainer/VBoxContainer.get_node(upgrade)
		if prodbar != null:
			prodbar.visible = true

	# Barter
	var barter_name = Global.upgrade_names[4]
	var barter_level = Global.upgrades[barter_name]
	var barter_perfect_being = barter_name + str(barter_level + 1)
	var barbar = $ScrollContainer/VBoxContainer.get_node(barter_perfect_being)
	if barbar != null and Global.count > (barter_level + 1) * 8:
		barbar.visible = true

	# Forges
	for i in range(Global.very_specific_iterator_in_shopping_manager, 15):
		var forge_name = Global.upgrade_names[i]
		var forbar = $ScrollContainer/VBoxContainer.get_node(forge_name)
		if forbar != null and Global.count > ((i - 4) * 8) - 1:
			forbar.visible = true
			Global.very_specific_iterator_in_shopping_manager += 1

#|===============================|
#| Grease 1-11:			ID  0-10 |
#| Overclock 1-11: 		ID 11-21 |
#| LSC 1-10:			ID 22-31 |
#| Melting 1-10:		ID 32-41 |
#| Barter 1-9:			ID 42-50 |
#| Forges:				ID 51-60 |
#|===============================|
