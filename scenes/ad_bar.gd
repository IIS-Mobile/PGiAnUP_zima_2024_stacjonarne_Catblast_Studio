extends Node

func _on_button_pressed() -> void:
	$"/root/Node2D".trigger_ad(10)
	$/root/Node2D/UI/VBoxContainer/CurrentView/ShopView/ScrollContainer/VBoxContainerWhole/MarginContainer/AdBar.hide()
	Global.premium_resource += 5
	Global.last_ad_use_time = Time.get_unix_time_from_system()
	$AppearanceTimer.start(Global.SHOP_AD_APPEARANCE_INTERVAL_MINUTES * 60)


func _on_appearance_timer_timeout() -> void:
	$/root/Node2D/UI/VBoxContainer/CurrentView/ShopView/ScrollContainer/VBoxContainerWhole/MarginContainer/AdBar.show()
