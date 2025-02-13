extends TextureButton

func _on_pressed() -> void:
	$/root/Node2D/UISound.play()
	await $"/root/Node2D".trigger_ad(5)
	hide()
	Global.buffer += 5 * Engine.physics_ticks_per_second * Global.SLOWDOWN_FACTOR
	Global.last_boost_use_time = Time.get_unix_time_from_system()
	$AppearanceTimer.start(Global.BOOST_APPEARANCE_INTERVAL_MINUTES * 60)

func _on_appearance_timer_timeout() -> void:
	show()
