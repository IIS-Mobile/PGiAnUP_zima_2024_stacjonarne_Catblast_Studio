extends Node2D


func _ready() -> void:
	Global.connect("rotation_completed", _on_gear_container_rotation_completed)
	load_game_data()
	
func _on_gear_button_pressed() -> void:
	$UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer.add_gear()

func _on_gear_container_rotation_completed(index: int) -> void:

	var resource_name = Global.resource_names[index / Global.TIERS_AMOUNT]
	var tier = index % Global.TIERS_AMOUNT
	Global.resources[resource_name][tier] += 1

func _on_boost_button_pressed() -> void:
	Global.buffer += 5 * Engine.physics_ticks_per_second * Global.SLOWDOWN_FACTOR

func _on_idle_button_pressed() -> void:
	Global.idle = not Global.idle
	if Global.taps_count >= Global.STEAM_LIMIT:
		Global.release_steam.emit()
	else:
		print("NIEEEE NIE MOZESZ JESZCZE IDLOWAC MUSISZ NAPOMPOWAC PARY DO KOMORY")

func _notification(what):
	if what == NOTIFICATION_APPLICATION_PAUSED:
		save_game_data()

func save_game_data():
	print("Saving game...")

	var save_data = {
		"save_unix_time" : Time.get_unix_time_from_system(),
		"resources" : Global.resources,
		"current_top_tiers" : Global.current_top_tiers,
		"current_top_resource" : Global.current_top_resource,
		"gears_count" : Global.count
	}

	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved!")

func load_game_data():
	print("Loading game...")

	if not FileAccess.file_exists("user://savegame.json"):
		print("No savegame found!")
		return

	var save_file = FileAccess.open("user://savegame.json", FileAccess.READ)
	
	var json = JSON.new()
	var content = save_file.get_as_text()
	save_file.close()
	var parse_err = json.parse(content)

	if parse_err != OK:
		print("Error parsing savegame!")
		return

	if json.data.has("resources"):
		Global.resources = json.data.get("resources")
	if json.data.has("current_top_tiers"):
		Global.current_top_tiers = json.data.get("current_top_tiers")
	if json.data.has("current_top_resource"):
		Global.current_top_resource = json.data.get("current_top_resource")
	if json.data.has("gears_count"):
		var gears_count = json.data.get("gears_count")
		for i in range(gears_count):
			$UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer.add_gear()

		print("Game loaded!")
	else:
		print("No savegame found!")
