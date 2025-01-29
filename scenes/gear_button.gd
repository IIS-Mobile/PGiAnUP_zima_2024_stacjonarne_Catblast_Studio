extends Button

func on_button_pressed():
	$"/root/Node2D/UISound".play()
	var gears_view = get_parent().get_parent().get_parent().get_node("CurrentView/GearsView")
	var shop_view = get_parent().get_parent().get_parent().get_node("CurrentView/ShopView")
	
	shop_view.visible = false
	gears_view.visible = true	
	

func _ready():
	connect("pressed", on_button_pressed)
