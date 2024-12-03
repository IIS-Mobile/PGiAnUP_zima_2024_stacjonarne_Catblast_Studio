extends Node2D

@onready var IdleTimer = $IdleTimer

const IDLING_TIME = 30.0 # in seconds 

func _ready():
	Global.connect("begin_idling", handle_idling)

func handle_idling(idling_time):
	Global.idle = true
	IdleTimer.start(idling_time)

func _on_idle_timer_timeout():
	Global.idle = false

func get_remaining_idle_time():
	if  IdleTimer:
		return IdleTimer.time_left
