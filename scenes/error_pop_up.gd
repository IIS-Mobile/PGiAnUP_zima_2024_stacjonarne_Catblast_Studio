extends PanelContainer

var hide_timer: Timer
@onready var error_label: Label = $VBoxContainer/Label

func _ready() -> void:
	hide_timer = Timer.new()
	hide_timer.one_shot = true
	hide_timer.wait_time = 3.0
	add_child(hide_timer)
	hide_timer.timeout.connect(_on_hide_timer_timeout)
	visibility_changed.connect(_on_visibility_changed)
	visible = false  # Hide by default
	print(self.get_path()) 

func show_error(text: String) -> void:
	error_label.text = text
	visible = true

func _on_visibility_changed() -> void:
	if visible:
		hide_timer.start()

func _on_hide_timer_timeout() -> void:
	visible = false
