extends CanvasLayer

var seconds = 0
var can_skip = false

func start(secs: int):
	seconds = secs
	can_skip = false
	$Ad/SkipButton.text = str(seconds)
	$Timer.start()

func _on_timer_timeout() -> void:
	if seconds > 1:
		seconds -= 1
		$Ad/SkipButton.text = str(seconds)
	elif seconds == 1:
		$Timer.stop()
		$Ad/SkipButton.text = "Skip"
		can_skip = true

func _on_skip_button_pressed() -> void:
	if can_skip:
		$/root/Node2D/UISound.play()
		Global.ad_skipped.emit()
