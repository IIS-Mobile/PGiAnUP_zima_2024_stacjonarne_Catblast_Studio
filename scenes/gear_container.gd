extends Node2D

signal rotation_completed(index)

var gears = 0

func add_gear() -> void:
	# TODO: placeholder
	if gears >= 16:
		pass
	var gear = Gear.create()
	var x_pos = gears % 4
	var y_pos = 192 + (gears / 4) * 348
	if (gears / 4) % 2:
		x_pos = 3 - x_pos
	#TODO: placeholder
	if gears != 15 and gears % 4 == 3:
		y_pos += 58
	elif gears != 0 and gears % 4 ==0:
		y_pos -= 58
	gear.position = Vector2(192 + x_pos * 232, y_pos)
	gear.z_index = gears % 2
	gears += 1
	add_child(gear)

func _physics_process(_delta: float) -> void:
	Gear.speed = max(Gear.speed * 0.99, 0)

func _on_texture_button_pressed() -> void:
	if gears:
		Gear.speed = min(Gear.speed + 0.1, 1.0)

func _on_rotation_completed(index: Variant) -> void:
	if not index:
		$Sound.play()
