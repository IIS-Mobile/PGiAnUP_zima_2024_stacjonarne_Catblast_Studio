extends PanelContainer


func _ready():
	$Background/VBoxContainer/ToggleMelting/ToggleMeltingButton.pressed.connect(_on_toggle_melting_pressed)
	$Background/VBoxContainer/ToggleBarter/ToggleBarterButton.pressed.connect(_on_toggle_barter_pressed)
	$Background/VBoxContainer/MusiVolumeRect/MusiVolumeRectSlider.value_changed.connect(_on_music_volume_changed)
	$Background/VBoxContainer/SoundVolumeRect/SoundVolumeRectSlider.value_changed.connect(_on_sound_volume_changed)

func _on_toggle_melting_pressed():
	Global.is_melting_on = !Global.is_melting_on
	print("Global.is_melting_on:", Global.is_melting_on)
	$Background/VBoxContainer/ToggleMelting/ToggleMeltingButton.button_pressed = Global.is_melting_on

func _on_toggle_barter_pressed():
	Global.is_barter_on = !Global.is_barter_on
	print("Global.is_barter_on:", Global.is_barter_on)
	$Background/VBoxContainer/ToggleBarter/ToggleBarterButton.button_pressed = Global.is_barter_on
	
func _on_music_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	Global.music_volume = value

func _on_sound_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(value))
	Global.sound_volume = value

	
	
