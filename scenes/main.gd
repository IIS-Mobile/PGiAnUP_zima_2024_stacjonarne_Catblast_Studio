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
		"resources": [int(counter[0].text), int(counter[1].text), int(counter[2].text)]
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved!")

func load_game_data():
	print("Loading game...")
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if file != null:
		var json = JSON.new()
		var content = file.get_as_text()
		file.close()
		json.parse(content)
		
		for i in range(3):
			counter[i].text = str(json.data.get("resources")[i])

		print("Game loaded!")
	else:
		print("No savegame found!")
