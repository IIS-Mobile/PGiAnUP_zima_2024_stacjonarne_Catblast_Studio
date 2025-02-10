extends Control

var iterator = 0.01
var index = 0
var animation = false

const MAX_GAUGE_ANGLE: float = 135.0
const MIN_GAUGE_ANGLE: float = -135.0

func _ready() -> void:
	Global.connect("release_steam", release_steam)
	Global.connect("tap_performed", increment_taps)
	$Panel/Container/ProgressBar.max_value = Global.STEAM_LIMIT
	$Panel/Container/ProgressBar2.max_value = 1
	$Panel/Container/Whistle/CPUParticles2D.emitting = false
	
func _process(delta: float) -> void:
	$Panel/Container/ProgressBar2.value = Global.buffer
	
	waving_steam()
	if(index <= -0.1 or index >= 0.1):
		iterator = -iterator
	index += iterator
	if not animation:
		handle_gauge(Global.idle_time, Global.MAX_IDLE_TIME_HOURS * 3600)

func increment_taps():
	if Global.taps_count < Global.STEAM_LIMIT:
		Global.taps_count += 1
		$Panel/Container/ProgressBar.value = Global.taps_count
		Global.current_steam_chamber_value = $Panel/Container/ProgressBar.value

func waving_steam():
	$Panel/Container/ProgressBar.get_theme_stylebox("fill").skew.y = pow(index, 2.0) + index - pow(index, 3.0)
	$Panel/Container/ProgressBar2.get_theme_stylebox("fill").skew.y = pow(index, 2.0) + index - pow(index, 3.0)

func release_steam():
	$WhistleSound.play()
	animation = true
	#TODO: replace with fixed length animation to match sound
	for i in range (Global.STEAM_LIMIT, 0, -1):
		if i%2:
			await get_tree().create_timer(0.0001).timeout
			#handle_gauge(Global.taps_count, Global.STEAM_LIMIT)
		Global.taps_count = i
		$Panel/Container/ProgressBar.value = Global.taps_count
		Global.current_steam_chamber_value = $Panel/Container/ProgressBar.value
		
		$Panel/Container/Whistle/CPUParticles2D.emitting = true
		handle_gauge(Global.STEAM_LIMIT - Global.taps_count, Global.STEAM_LIMIT)
	animation = false
	$Panel/Container/Whistle/CPUParticles2D.emitting = false
	Global.idle_time = Global.MAX_IDLE_TIME_HOURS * 3600

func handle_gauge(remaining_time, total_time):
	var progress = remaining_time / total_time
	var angle = lerp(MIN_GAUGE_ANGLE, MAX_GAUGE_ANGLE, progress)
	$Panel/Container/SteamGauge/GaugeHand.rotation_degrees = angle
	Global.current_steam_chamber_value = $Panel/Container/SteamGauge/GaugeHand.rotation_degrees
