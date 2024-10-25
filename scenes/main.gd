extends Node2D
class_name main

@onready var counter = get_node("UI/Labels/Label_resource1")

func _ready() -> void:
	counter.text = "0"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		counter.text = str(int(counter.text)+1)
		gear.speed = min(gear.speed + 0.1, 1.0)

func _physics_process(_delta: float) -> void:
	gear.speed = max(gear.speed * 0.99, 0)
