extends TextureButton

#TODO: delete
func percent_to_pixels(percent: float) -> int:
	return (percent * 0.01 * 2000) as int

#TODO: turn into "refresh" function
func add_gear() -> void:
	if Global.count >= Global.MAX_GEARS:
		return
	var gear = Gear.create()
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
	$Gears.add_child(gear)
	$PlaceSound.play()
	_on_resized()

func _on_pressed() -> void:
	if Global.count:
		Global.tap_performed.emit()
		Global.buffer = min(Global.buffer + 0.1, 1.0)

func _on_resized() -> void:
	$Gears.scale = Vector2.ONE * (size.x as float / 2000.0)
	var container_height = (((Global.count + (Global.GEARS_PER_ROW - 1)) / Global.GEARS_PER_ROW) * $Gears.scale.y * percent_to_pixels(28)) + $Gears.scale.y * percent_to_pixels(9)
	#TODO: find a better way to fix crashing
	if container_height - get_parent().size.y > 1:
		custom_minimum_size.y = container_height
