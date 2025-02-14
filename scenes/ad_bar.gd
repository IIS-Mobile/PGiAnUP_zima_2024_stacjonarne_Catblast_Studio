extends Panel

func _on_button_pressed() -> void:
	$/root/Node2D/UISound.play()
	await $"/root/Node2D".trigger_ad(10)
	hide()
	Global.premium_resource += 5
	Global.last_ad_use_time = Time.get_unix_time_from_system()
	$AppearanceTimer.start(Global.SHOP_AD_APPEARANCE_INTERVAL_MINUTES * 60)

func _on_appearance_timer_timeout() -> void:
	show()
