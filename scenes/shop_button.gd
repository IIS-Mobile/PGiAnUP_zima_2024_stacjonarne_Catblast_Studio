extends Button

# Function to handle the scene change
func on_button_pressed():
	$"/root/Node2D/UISound".play()
	var gears_view = get_parent().get_parent().get_parent().get_node("CurrentView/GearsView")
	var shop_view = get_parent().get_parent().get_parent().get_node("CurrentView/ShopView")
	var settings_view = get_parent().get_parent().get_parent().get_node("CurrentView/SettingsView")
	
	gears_view.visible = false
	settings_view.visible = false
	shop_view.visible = true
	


func _ready():
	# Connect the button press signal to the function that will handle the scene change
	connect("pressed", on_button_pressed)
