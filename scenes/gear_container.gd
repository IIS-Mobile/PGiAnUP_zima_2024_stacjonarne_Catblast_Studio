extends TextureButton

signal rotation_completed(index:int)

const SLOWDOWN_FACTOR = 0.005
const IDLE_SPEED = 0.1
var idle = true

func percent_to_pixels(percent: float) -> int:
	return (percent * 0.01 * self.size[0] as float) as int

func add_gear() -> void:
	# TODO: placeholder
	if Gear.count >= 16:
		return
	var gear = Gear.create()
	var x_pos = Gear.count % 4
	var y_pos = percent_to_pixels(18.5) + (Gear.count / 4) * percent_to_pixels(28)
	if (Gear.count / 4) % 2:
		x_pos = 3 - x_pos
	#TODO: placeholder
	if Gear.count != 15 and Gear.count % 4 == 3:
		y_pos += percent_to_pixels(4.5)
	elif Gear.count != 0 and Gear.count % 4 ==0:
		y_pos -= percent_to_pixels(4.5)
	gear.position = Vector2(percent_to_pixels(18.5) + x_pos * percent_to_pixels(21), y_pos)
	gear.z_index = Gear.count % 2
	add_child(gear)

func _physics_process(_delta: float) -> void:
	if Gear.speed == 1.0:
		if Gear.buffer > 0.0:
			Gear.buffer = max(Gear.buffer - SLOWDOWN_FACTOR, 0.0)
		else:
			Gear.speed = max(Gear.speed - SLOWDOWN_FACTOR, 0.0)
	else:
		if Gear.buffer > 0.0:
			Gear.buffer = max(Gear.buffer - SLOWDOWN_FACTOR, 0.0)
			Gear.speed = min(Gear.speed + SLOWDOWN_FACTOR, 1.0)
		else:
			Gear.speed = max(Gear.speed - SLOWDOWN_FACTOR, 0.0)
	if idle and Gear.speed < IDLE_SPEED:
		Gear.buffer = min(Gear.buffer + SLOWDOWN_FACTOR, 1.0)

func _on_rotation_completed(index: int) -> void:
	if not index:
		$Sound.play()

func _on_pressed() -> void:
	if Gear.count:
		Gear.buffer = min(Gear.buffer + 0.1, 1.0)
