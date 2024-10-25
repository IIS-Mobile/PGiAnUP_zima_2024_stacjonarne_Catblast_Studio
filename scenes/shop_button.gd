extends TextureButton

# Function to handle the scene change
func on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/shop.tscn")


func _ready():
	# Connect the button press signal to the function that will handle the scene change
	connect("pressed", on_button_pressed)
