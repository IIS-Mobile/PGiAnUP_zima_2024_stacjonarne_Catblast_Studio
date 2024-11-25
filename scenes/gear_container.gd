extends TextureButton

func _ready() -> void:
	Global.connect("rotation_completed", _on_rotation_completed)
	
func percent_to_pixels(percent: float) -> int:
	return (percent * 0.01 * self.size[0] * 0.6) as int


func add_gear() -> void:
	if Global.count >= Global.MAX_GEARS:
		return
	var gear = Gear.create()
	gear.scale = Vector2(0.6, 0.6) #placeholder solution
	
	var x_pos = Global.count % Global.GEARS_PER_ROW
	var y_pos = percent_to_pixels(18.5) + (Global.count / Global.GEARS_PER_ROW) * percent_to_pixels(28)
	if (Global.count / Global.GEARS_PER_ROW) % 2:
		x_pos = (Global.GEARS_PER_ROW - 1) - x_pos
	if Global.count != (Global.MAX_GEARS - 1) and Global.count % Global.GEARS_PER_ROW == Global.GEARS_PER_ROW - 1:
		y_pos += percent_to_pixels(4.5)
	elif Global.count != 0 and Global.count % Global.GEARS_PER_ROW == 0:
		y_pos -= percent_to_pixels(4.5)
	gear.position = Vector2(percent_to_pixels(18.5) + x_pos * percent_to_pixels(21), y_pos)
	gear.z_index = Global.count % 2
	add_child(gear)
	update_gear_container_size()


func update_gear_container_size() -> void:
	var current_row_amount = 1 + Global.count / Global.GEARS_PER_ROW
	custom_minimum_size.y = current_row_amount * percent_to_pixels(28.5);

	
#TODO: move somewhere else?
func _on_rotation_completed(index: int) -> void:
	if not index:
		$Sound.play()

func _on_pressed() -> void:
	if Global.count:
		Global.buffer = min(Global.buffer + 0.1, 1.0)
		Global.tap_performed.emit()
