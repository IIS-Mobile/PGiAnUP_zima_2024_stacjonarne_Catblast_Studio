extends Node2D

@onready var counter = [get_node("UI/VBoxContainer/ColorRect/Resource1/Label_resource2"),get_node("UI/VBoxContainer/ColorRect/Resource2/Label_resource2"),get_node("UI/VBoxContainer/ColorRect/Resource3/Label_resource1")]

func _on_gear_button_pressed() -> void:
	$UI/VBoxContainer/HSplitContainer/ScrollContainer/GearContainer.add_gear()

func _on_gear_container_rotation_completed(index: Variant) -> void:
	#TODO: placeholder
	if index / 4 != 3:
		var counter = counter[index / 4]
		counter.text = str(int(counter.text) + 1)
