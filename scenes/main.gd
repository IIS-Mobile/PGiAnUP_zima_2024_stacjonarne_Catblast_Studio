extends Node2D

func _on_gear_button_pressed() -> void:
	$UISound.play()
	$UI/VBoxContainer/CurrentView/GearsView/ScrollContainer/GearContainer.add_gear()

func _on_boost_button_pressed() -> void:
	$UISound.play()
	Global.buffer += 5 * Engine.physics_ticks_per_second * Global.SLOWDOWN_FACTOR

func _on_idle_button_pressed() -> void:
	$UISound.play()
	if Global.taps_count >= Global.STEAM_LIMIT:
		Global.release_steam.emit()
	else:
		print("NIEEEE NIE MOZESZ JESZCZE IDLOWAC MUSISZ NAPOMPOWAC PARY DO KOMORY")

func _on_test_idle_button_pressed() -> void:
	$UISound.play()
	Global.calc_idle_resources(8 * 3600)
