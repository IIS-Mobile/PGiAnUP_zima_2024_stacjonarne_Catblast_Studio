extends Node2D


func _ready() -> void:
	Global.connect("idle_button_clicked", idle_button_clicked)
	Global.stop_purchasing_gears = true
	load_game_data()
	Global.stop_purchasing_gears = false
	Global.emit_signal("reload_shop")

#reward user after executing this function eg. $"/root/Node2D".trigger_ad(10)
func trigger_ad(secs: int):
	$AdView.start(secs)
	for b in range(0, AudioServer.bus_count):
		AudioServer.set_bus_mute(b, true)
	$UI.visible = false
	$AdView.visible = true
	await Global.ad_skipped
	for b in range(0, AudioServer.bus_count):
		AudioServer.set_bus_mute(b, false)
	$UI.visible = true
	$AdView.visible = false

func _on_gear_button_pressed() -> void:
	$UISound.play()
	$UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer/PlaceSound.play()
	$UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer.add_gear()

func idle_button_clicked():
	$UISound.play()
	if Global.taps_count >= Global.lsc_tap_scaling():
		Global.release_steam.emit()
	else:
		print("NIEEEE NIE MOZESZ JESZCZE IDLOWAC MUSISZ NAPOMPOWAC PARY DO KOMORY")

func _on_save_test_pressed() -> void:
	save_game_data()
	
func _on_delete_save_test_pressed() -> void:
	print("Save removed...")
	DirAccess.remove_absolute("user://savegame.json")

func _notification(what):
	if what == NOTIFICATION_APPLICATION_PAUSED:
		save_game_data()

func save_game_data():
	print("Saving game...")

	var res_copy_for_serialization = Global.resources.duplicate(true)
	for key : String in res_copy_for_serialization:
		for entry_idx : int in res_copy_for_serialization[key].size():
			res_copy_for_serialization[key][entry_idx] = res_copy_for_serialization[key][entry_idx].toScientific()
	var save_data = {
		"music_volume": Global.music_volume,
		"sound_volume": Global.sound_volume,
		"very_specific_iterator_in_shopping_manager": Global.very_specific_iterator_in_shopping_manager,
		"premium_resource": Global.premium_resource,
		"last_ad_use_time": Global.last_ad_use_time,
		"last_boost_use_time": Global.last_boost_use_time,
		"idle_time": Global.idle_time,
		"phases": Global.phases,
		"save_unix_time" : Time.get_unix_time_from_system(),
		"resources" : res_copy_for_serialization,
		"current_top_tiers" : Global.current_top_tiers,
		"current_top_resource" : Global.current_top_resource,
		"gears_count" : Global.count,
		"upgrades" : Global.upgrades,
		"is_melting_on " : Global.is_melting_on,
		"is_barter_on" : Global.is_barter_on,
		"taps_count" : Global.taps_count
	}

	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved!")

func load_game_data():
	print("Loading game...")

	if not FileAccess.file_exists("user://savegame.json"):
		print("No savegame found!")
		# init phases if no save state available
		Global.phases.resize(Global.MAX_GEARS)
		Global.phases.fill(0.0)
		$UI/VBoxContainer/CurrentView/ShopView/ScrollContainer/VBoxContainerWhole/MarginContainer/AdBar.show()
		$UI/VBoxContainer/CurrentView/GearsView/Panel/ColorRect/SteamChamber/Panel/BoostButton.show()

		return
	var save_file = FileAccess.open("user://savegame.json", FileAccess.READ)
	
	var json = JSON.new()
	var content = save_file.get_as_text()
	save_file.close()
	var parse_err = json.parse(content)

	if parse_err != OK:
		print("Error parsing savegame!")
		return
	if json.data.has("phases"):
		Global.phases = json.data.get("phases")
	else:
		# init phases if no save state available
		Global.phases.resize(Global.MAX_GEARS)
		Global.phases.fill(0.0)
	if json.data.has("resources"):
		var json_resource_data = json.data.get("resources")
		for key : String in json_resource_data:
			for tier_idx : int in json_resource_data[key].size():
				Global.resources[key][tier_idx] = Big.new(json_resource_data[key][tier_idx])

	if json.data.has("music_volume"):
		Global.music_volume = json.data.get("music_volume")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(min(1., Global.music_volume)))
		$/root/Node2D/UI/VBoxContainer/CurrentView/SettingsView/Background/VBoxContainer/Panel/MusiVolumeRect/MusiVolumeRectSlider.value = Global.music_volume
	if json.data.has("sound_volume"):
		Global.sound_volume = json.data.get("sound_volume")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db(min(1., Global.sound_volume)))
		$/root/Node2D/UI/VBoxContainer/CurrentView/SettingsView/Background/VBoxContainer/Panel2/SoundVolumeRect/SoundVolumeRectSlider.value = Global.sound_volume
	if json.data.has("very_specific_iterator_in_shopping_manager"):
		Global.very_specific_iterator_in_shopping_manager = json.data.get("very_specific_iterator_in_shopping_manager")
	if json.data.has("premium_resource"):
		Global.premium_resource = json.data.get("premium_resource")
	if json.data.has("current_top_tiers"):
		Global.current_top_tiers = json.data.get("current_top_tiers")
	if json.data.has("current_top_resource"):
		Global.current_top_resource = json.data.get("current_top_resource")
	if json.data.has("gears_count"):
		var gears_count = json.data.get("gears_count")
		for i in range(gears_count):
			$UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer.add_gear()
	if json.data.has("upgrades"):
		Global.upgrades = json.data.get("upgrades")
	if json.data.has("is_melting_on"):
		Global.is_melting_on = json.data.get("is_melting_on")
		$/root/Node2D/UI/VBoxContainer/CurrentView/SettingsView/Background/VBoxContainer/ToggleMelting/ToggleMeltingButton.button_pressed = Global.is_melting_on
	if json.data.has("is_barter_on"):
		Global.is_barter_on = json.data.get("is_barter_on")
		$/root/Node2D/UI/VBoxContainer/CurrentView/SettingsView/Background/VBoxContainer/ToggleBarter/ToggleBarterButton.button_pressed = Global.is_barter_on
	if json.data.has("taps_count"):
		Global.taps_count = json.data.get("taps_count")
	if json.data.has("last_boost_use_time"):
		Global.last_boost_use_time = json.data.get("last_boost_use_time")
		if Time.get_unix_time_from_system() - Global.last_boost_use_time > Global.BOOST_APPEARANCE_INTERVAL_MINUTES * 60:
			$UI/VBoxContainer/CurrentView/GearsView/Panel/ColorRect/SteamChamber/Panel/BoostButton.show()
		else:
			$UI/VBoxContainer/CurrentView/GearsView/Panel/ColorRect/SteamChamber/Panel/BoostButton/AppearanceTimer.start(Global.BOOST_APPEARANCE_INTERVAL_MINUTES * 60 - (Time.get_unix_time_from_system() - Global.last_boost_use_time))
	if json.data.has("last_ad_use_time"):
		Global.last_ad_use_time = json.data.get("last_ad_use_time")
		if Time.get_unix_time_from_system() - Global.last_ad_use_time > Global.SHOP_AD_APPEARANCE_INTERVAL_MINUTES * 60:
			$UI/VBoxContainer/CurrentView/ShopView/ScrollContainer/VBoxContainerWhole/MarginContainer/AdBar.show()
		else:
			$UI/VBoxContainer/CurrentView/ShopView/ScrollContainer/VBoxContainerWhole/MarginContainer/AdBar/AppearanceTimer.start(Global.SHOP_AD_APPEARANCE_INTERVAL_MINUTES * 60 - (Time.get_unix_time_from_system() - Global.last_ad_use_time))
	# has to be at the end in order to avoid values being overwritten and upgrades being taken into account
	if json.data.has("save_unix_time"):
		var away_time = max(0, Time.get_unix_time_from_system() - json.data.get("save_unix_time"))
		var idle_time = min(json.data.get("idle_time"), away_time)
		Global.calc_idle_resources(idle_time)
		Global.idle_time = json.data.get("idle_time") - idle_time
	print("Game loaded!")
