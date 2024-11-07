extends Node2D

var counter

func _ready():
	counter = get_node("UI/VBoxContainer/ColorRect/Resource1/Label_resource2")
	load_game_data()

func _on_gear_button_pressed() -> void:
	$UI/VBoxContainer/HSplitContainer/ScrollContainer/GearContainer.add_gear()

func _on_gear_container_rotation_completed(index: Variant) -> void:
	#TODO: placeholder
	counter.text = str(int(counter.text) + 1)
	pass

func save_game_data():
	print(counter.get_text())
	var save_data = {
		"resources": [int(counter.get_text())]
		# "resources": [int(counter[0].text), int(counter[1].text), int(counter[2].text), int(counter[3].text)],
		# "gears": []
	}
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Game saved!")

func load_game_data():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if file != null:
		var save_data = JSON.new()
		var json = JSON.new()
		save_data = json.parse(file.get_as_text())
		file.close()
		print("Loaded data: ", save_data)
		# for i in range(4):
			# counter[i].text = str(save_data["resources"][i])
		# counter.text = str(save_data["resources"][0])
		print("Game loaded!")
	else:
		print("No savegame found!")

func _notification(what):
	if what == NOTIFICATION_APPLICATION_PAUSED:
		save_game_data()
