extends PanelContainer


func _ready():
	$Background/VBoxContainer/Panel3/ToggleMelting/ToggleMeltingButton.pressed.connect(_on_toggle_melting_pressed)
	$Background/VBoxContainer/Panel4/ToggleBarter/ToggleBarterButton.pressed.connect(_on_toggle_barter_pressed)
	$Background/VBoxContainer/Panel/MusiVolumeRect/MusiVolumeRectSlider.value_changed.connect(_on_music_volume_changed)
	$Background/VBoxContainer/Panel2/SoundVolumeRect/SoundVolumeRectSlider.value_changed.connect(_on_sound_volume_changed)

func _on_toggle_melting_pressed():
	Global.is_melting_on = !Global.is_melting_on
	print("Global.is_melting_on:", Global.is_melting_on)
	$Background/VBoxContainer/Panel3/ToggleMelting/ToggleMeltingButton.button_pressed = Global.is_melting_on

func _on_toggle_barter_pressed():
	Global.is_barter_on = !Global.is_barter_on
	print("Global.is_barter_on:", Global.is_barter_on)
	$Background/VBoxContainer/Panel4/ToggleBarter/ToggleBarterButton.button_pressed = Global.is_barter_on
	
func _on_music_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	Global.music_volume = value

func _on_sound_volume_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(value))
	Global.sound_volume = value
