extends PanelContainer


func _ready():
	$Background/VBoxContainer/ToggleMelting/ToggleMeltingButton.pressed.connect(_on_toggle_melting_pressed)
	$Background/VBoxContainer/ToggleBarter/ToggleBarterButton.pressed.connect(_on_toggle_barter_pressed)
	update_buttons()

func _on_toggle_melting_pressed():
	Global.is_melting_on = !Global.is_melting_on
	print("Global.is_melting_on:", Global.is_melting_on)
	update_buttons()

func _on_toggle_barter_pressed():
	Global.is_barter_on = !Global.is_barter_on
	print("Global.is_barter_on:", Global.is_barter_on)
	update_buttons()

func update_buttons():
	$Background/VBoxContainer/ToggleMelting/ToggleMeltingButton.button_pressed = Global.is_melting_on
	$Background/VBoxContainer/ToggleBarter/ToggleBarterButton.button_pressed = Global.is_barter_on
