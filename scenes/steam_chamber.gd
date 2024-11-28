extends Control

var iterator = 0.01
var index

func _ready() -> void:
	Global.connect("release_steam", release_steam)
	Global.connect("tap_performed", increment_taps)
	$Panel/Container/ProgressBar.max_value = Global.STEAM_LIMIT
	$Panel/Container/ProgressBar2.max_value = 1
	$Panel/Container/Whistle/CPUParticles2D.emitting = false
	index = 0
	
func _process(delta: float) -> void:
	$Panel/Container/ProgressBar2.value = Global.buffer
	waving_steam(index)
	if(index <= -0.1 or index >= 0.1):
		iterator = -iterator
	index += iterator

func increment_taps():
	if Global.taps_count < Global.STEAM_LIMIT and Global.idle == false:
		Global.taps_count += 1
		$Panel/Container/ProgressBar.value = Global.taps_count
		
func waving_steam(index):
	$Panel/Container/ProgressBar.get_theme_stylebox("fill").skew.y = pow(index, 2.0) + index - pow(index, 3.0)
	$Panel/Container/ProgressBar2.get_theme_stylebox("fill").skew.y = pow(index, 2.0) + index - pow(index, 3.0)
	
func release_steam():
	for i in range (Global.STEAM_LIMIT, 0, -1):
		if i%2:
			await get_tree().create_timer(0.0001).timeout
		Global.taps_count = i
		$Panel/Container/ProgressBar.value = Global.taps_count
		$Panel/Container/Whistle/CPUParticles2D.emitting = true
	$Panel/Container/Whistle/CPUParticles2D.emitting = false
