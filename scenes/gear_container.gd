extends TextureButton

#TODO: delete
func percent_to_pixels(percent: float) -> int:
	return (percent * 0.01 * 2000) as int
func add_gear() -> void:
	if not pay_for_gear():  # Ensure the player can afford it before proceeding
		return
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
	_on_resized()
	Global.emit_signal("reload_shop")


func _on_pressed() -> void:
	if Global.count:
		Global.tap_performed.emit()
		Global.buffer = min(Global.buffer + 0.1, 1.0)


func _on_resized() -> void:
	$Gears.scale = Vector2.ONE * (size.x as float / 2000.0)
	var container_height = (((Global.count + (Global.GEARS_PER_ROW - 1)) / Global.GEARS_PER_ROW) * $Gears.scale.y * percent_to_pixels(28)) + $Gears.scale.y * percent_to_pixels(9)
	if container_height - get_parent().size.y > 1:
		custom_minimum_size.y = container_height


func _process(delta: float) -> void:
	check_new_gear_affordability()


func check_new_gear_affordability() -> void:
	if Global.count >= Global.MAX_GEARS:
		update_buy_button(false)
		return  # No more gears can be bought

	var cost = get_gear_cost(Global.count)
	var can_afford = has_enough_resources(cost)

	update_buy_button(can_afford)


func get_gear_cost(count: int) -> Dictionary:
	if count == 0:
		return {}  # Gear 0 is free

	var resource_index = (count - 1 if count <= 7 else 0 ) / 9  # Every 9 gears, switch resource
	var tier = (count - 1 if count <= 7 else 0 ) % 9  # 0-8: normal tier progression, resets at 9
	var amount = Big.new(30)  # Constant for now

	# Ensure the list has exactly 8 elements
	var cost_list = [Big.new(0),Big.new(0),Big.new(0),Big.new(0),Big.new(0),Big.new(0),Big.new(0),Big.new(0)]
	cost_list[tier] = amount
	var premium_cost =count*10
	
	return {resource_index: cost_list, "premium" : premium_cost}


func has_enough_resources(cost: Dictionary) -> bool:
	for resource in cost.keys():
		#this for is needed if we want different mix of tiers, for now its redundant
		for tier in range(cost[resource].size()):
			if Global.resources[Global.resource_names[resource]][tier].isLessThan(cost[resource][tier]):
				return false
	return true


func pay_for_gear() -> bool:
	# Free first gear
	if Global.count == 0:
		return true
	
	var cost = get_gear_cost(Global.count)

	if has_enough_resources(cost):
		# Deduct normal resources
		for resource in cost.keys():
			for tier in range(cost[resource].size()):
				Global.resources[resource][tier].minusEquals(cost[resource][tier])
		return true  # Purchase successful

	# If normal resources aren't enough, try using premium
	print("Not enough resources, gear_container.gd@81, falling back to premium res")
	if Global.premium_resource >= cost["premium"]:
		Global.premium_resource -= cost["premium"]
		return true
	
	return false  # Can't afford it



func update_buy_button(enabled: bool) -> void:
	pass
