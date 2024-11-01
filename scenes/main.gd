extends Node2D

@onready var counter = [get_node("UI/Labels/Label_resource1"),get_node("UI/Labels/Label_resource2"),get_node("UI/Labels/Label_resource3"),get_node("UI/Labels/Label_resource4")]

func _on_gear_button_pressed() -> void:
	$GearContainer.add_gear()

func _on_gear_container_rotation_completed(index: Variant) -> void:
	#TODO: placeholder
	var counter = counter[index / 4]
	counter.text = str(int(counter.text) + 1)
