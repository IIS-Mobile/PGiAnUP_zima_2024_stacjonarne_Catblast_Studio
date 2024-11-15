extends Button

# Function to handle the scene change
func on_button_pressed():
	var gears_view = get_parent().get_parent().get_parent().get_node("CurrentView/GearsView")
	var shop_view = get_parent().get_parent().get_parent().get_node("CurrentView/ShopView")
	
	gears_view.visible = false	
	shop_view.visible = true
	


func _ready():
	# Connect the button press signal to the function that will handle the scene change
	connect("pressed", on_button_pressed)
