extends ScrollContainer

var is_dragging := false
var last_touch_position := Vector2()
var velocity := Vector2()
var friction := 0.95  # Zwiększone tarcie dla dłuższego efektu ślizgu
var min_velocity := 5 # Zmniejszony próg zatrzymania

func _ready():
	# Ukryj paski przewijania
	get_v_scroll_bar().visible = false
	get_h_scroll_bar().visible = false

func _process(delta):
	if not is_dragging:
		if velocity.length() > min_velocity:
			scroll_vertical -= velocity.y * delta
			scroll_horizontal -= velocity.x * delta
			velocity *= friction
		else:
			velocity = Vector2()

func _input(event):
	if event is InputEventScreenDrag:
		is_dragging = true
		var delta = event.relative
		scroll_vertical -= delta.y
		scroll_horizontal -= delta.x
		velocity = delta / get_process_delta_time()
	elif event is InputEventScreenTouch:
		if event.pressed:
			is_dragging = true
			velocity = Vector2()
			last_touch_position = event.position
		else:
			is_dragging = false
