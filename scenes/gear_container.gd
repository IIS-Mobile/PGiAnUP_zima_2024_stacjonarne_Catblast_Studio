extends TextureButton

signal rotation_completed(index)

var gears = 0

func percent_to_pixels(percent: float) -> int:
	return (percent * 0.01 * self.size[0] as float) as int

func add_gear() -> void:
	# TODO: placeholder
	if gears >= 16:
		return
	var gear = Gear.create()
	var x_pos = gears % 4
	var y_pos = percent_to_pixels(18.5) + (gears / 4) * percent_to_pixels(28)
	if (gears / 4) % 2:
		x_pos = 3 - x_pos
	#TODO: placeholder
	if gears != 15 and gears % 4 == 3:
		y_pos += percent_to_pixels(4.5)
	elif gears != 0 and gears % 4 ==0:
		y_pos -= percent_to_pixels(4.5)
	gear.position = Vector2(percent_to_pixels(18.5) + x_pos * percent_to_pixels(21), y_pos)
	gear.z_index = gears % 2
	gears += 1
	add_child(gear)

func _physics_process(_delta: float) -> void:
	Gear.speed = max(Gear.speed * 0.99, 0)

func _on_rotation_completed(index: Variant) -> void:
	if not index:
		$Sound.play()

func _on_pressed() -> void:
	if gears:
		Gear.speed = min(Gear.speed + 0.1, 1.0)
