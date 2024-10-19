extends Node2D

@onready var counter = get_node("Label")
@onready var icon = get_node("Icon")

func _ready() -> void:
	counter.text = "0"

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			on_icon_pressed()

func on_icon_pressed() -> void:
	var current_value = int(counter.text)
	current_value += 1
	counter.text = str(current_value)
