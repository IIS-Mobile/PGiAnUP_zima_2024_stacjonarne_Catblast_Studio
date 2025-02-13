extends Control

var iterator = 0.01
var index = 0
var animation = false

const MAX_GAUGE_ANGLE: float = 135.0
const MIN_GAUGE_ANGLE: float = -135.0

func _ready() -> void:
	Global.connect("release_steam", release_steam)
	Global.connect("tap_performed", increment_taps)
	$Panel/Container/ProgressBar2.max_value = 1
	$Panel/Container/Whistle/CPUParticles2D.emitting = false
	
func _process(_delta: float) -> void:
	$Panel/Container/ProgressBar2.value = Global.buffer
	
	waving_steam()
	if(index <= -0.1 or index >= 0.1):
		iterator = -iterator
	index += iterator
	if not animation:
		# TODO: avoid setting on each frame
		$Panel/Container/ProgressBar.max_value = Global.lsc_tap_scaling()
		$Panel/Container/ProgressBar.value = min(Global.taps_count, Global.lsc_tap_scaling()) 
		handle_gauge(Global.idle_time, Global.lsc_time_scaling() * 3600)

func increment_taps():
	$DropletSound.pitch_scale = max(0.1, Global.buffer)
	$DropletSound.play()
	if not animation and Global.taps_count < Global.lsc_tap_scaling():
		Global.taps_count += 1

func waving_steam():
	$Panel/Container/ProgressBar.get_theme_stylebox("fill").skew.y = pow(index, 2.0) + index - pow(index, 3.0)
	$Panel/Container/ProgressBar2.get_theme_stylebox("fill").skew.y = pow(index, 2.0) + index - pow(index, 3.0)

func release_steam():
	$WhistleSound.play()
	animation = true
	$Panel/Container/ProgressBar.max_value = 100
	$Panel/Container/Whistle/CPUParticles2D.emitting = true
	for i in range(0, 100):
		$Panel/Container/ProgressBar.value = 99 - i
		handle_gauge(i, 99.)
		await get_tree().create_timer(0.005).timeout
	$Panel/Container/Whistle/CPUParticles2D.emitting = false
	$Panel/Container/ProgressBar.max_value = Global.lsc_tap_scaling()
	animation = false
	Global.taps_count = 0
	Global.idle_time = Global.lsc_time_scaling() * 3600


func handle_gauge(remaining_time, total_time):
	var progress = remaining_time / total_time
	var angle = lerp(MIN_GAUGE_ANGLE, MAX_GAUGE_ANGLE, progress)
	$Panel/Container/SteamGauge/GaugeHand.rotation_degrees = angle

func _on_idle_button_pressed():
	Global.idle_button_clicked.emit()
