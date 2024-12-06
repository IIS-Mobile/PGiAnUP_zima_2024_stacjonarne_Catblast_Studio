extends PanelContainer

var is_product_affordable = [false, false, false, false]

func _process(delta):
	for i in range($VBoxContainer.get_child_count()):
		check_product_affordability(i)
		visual_update(i)
	
func check_product_affordability(product_index):
	var product_bar = $VBoxContainer.get_child(product_index)
	var is_affordable = true
	
	for resource_index in range(3):
		var resource_key = "resource" + str(resource_index + 1)
		var tier_key = "tier" + str(resource_index + 1)
		var price_key = "price" + str(resource_index + 1)

		var resource = Global.resources[product_bar.get(resource_key)][product_bar.get(tier_key)-1] 
																							   # ^NIE WIEM CZEMU TO -1 ALE INACZEJ NIEPOPRAWNIE DZIALA
		var price = product_bar.get(price_key)
		#print("-----------------")
		#print("PRODBAR: ", product_bar)
		#print("CENA: ", price)
		#print("ZASÓB: ", product_bar.get(resource_key))
		#print("TIER: ", product_bar.get(tier_key))
		
		var price_label = product_bar.get_child(0).get_child(4).get_child(resource_index)
		
		if resource < price:
			price_label.add_theme_color_override("font_color", Color(1, 0, 0, 1))
			is_affordable = false
		else:
			price_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
			

	is_product_affordable[product_index] = is_affordable

func visual_update(product_index):
	var product_bar = $VBoxContainer.get_child(product_index)
	var buy_button = product_bar.get_child(0).get_child(5).get_child(0)
	var premium_resource = buy_button.get_child(0).get_child(0)
	var premium_price = buy_button.get_child(0).get_child(1)
	
	if is_product_affordable[product_index]:
		buy_button.text = "BUY"
		premium_resource.hide()
		premium_price.hide()
	else:
		buy_button.text = ""
		premium_resource.show()
		premium_price.show()
