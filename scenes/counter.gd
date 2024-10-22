extends Node2D

@onready var counter = get_node("UI/Labels/Label_resource1")
@onready var icon = get_node("Icon")

func _ready() -> void:
	counter.text = "0"

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if is_click_inside_icon(event.position):
			on_icon_pressed()

func is_click_inside_icon(click_position: Vector2) -> bool:
	if icon.texture:
		var icon_rect = Rect2(icon.global_position - icon.texture.get_size() * icon.scale * 0.5, icon.texture.get_size() * icon.scale)
		return icon_rect.has_point(click_position)
	return false

func on_icon_pressed() -> void:
	var current_value = int(counter.text)
	current_value += 1
	counter.text = str(current_value)
	#placeholder/test
	icon.rotation += PI /16
