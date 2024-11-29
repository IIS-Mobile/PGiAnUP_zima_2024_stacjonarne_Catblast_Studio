extends Node2D

@onready var counter = [get_node("UI/VBoxContainer/ColorRect/Resource1/Label_resource2"),get_node("UI/VBoxContainer/ColorRect/Resource2/Label_resource2"),get_node("UI/VBoxContainer/ColorRect/Resource3/Label_resource1")]

func _ready() -> void:
	#TODO: is there a better way?
	Global.connect("rotation_completed", _on_gear_container_rotation_completed)
	load_game_data()
	
func _on_gear_button_pressed() -> void:
	$UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer.add_gear()

func _on_gear_container_rotation_completed(index: int) -> void:
	#TODO: placeholder
	if index / 4 != 3:
		var counter = counter[index / 4]
		counter.text = str(int(counter.text) + 1)


func _on_boost_button_pressed() -> void:
	#TODO: relate to physics fps
	Global.buffer += 5 * 60 * Global.SLOWDOWN_FACTOR


func _on_idle_button_pressed() -> void:
	Global.idle = not Global.idle

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
