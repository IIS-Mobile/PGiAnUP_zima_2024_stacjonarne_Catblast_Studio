extends Node2D


func _ready() -> void:
	Global.connect("rotation_completed", _on_gear_container_rotation_completed)
	
func _on_gear_button_pressed() -> void:
	$UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer.add_gear()

func _on_gear_container_rotation_completed(index: int) -> void:
	#TODO: placeholder
	if index / Global.TIERS_AMOUNT != 3:
		var resource_name = Global.resource_names[index / Global.TIERS_AMOUNT]
		Global.resources[resource_name][0] += 1


func _on_boost_button_pressed() -> void:
	Global.buffer += 5 * Engine.physics_ticks_per_second * Global.SLOWDOWN_FACTOR


func _on_idle_button_pressed() -> void:
	if Global.taps_count >= Global.STEAM_LIMIT:
		Global.idle = not Global.idle
		#Global.taps_count = 0
		Global.release_steam.emit()
	else:
		print("NIEEEE NIE MOZESZ JESZCZE IDLOWAC MUSISZ NAPOMPOWAC PARY DO KOMORY")
