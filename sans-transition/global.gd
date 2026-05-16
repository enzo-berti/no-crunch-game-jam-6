extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		get_window().mode = (
			Window.MODE_FULLSCREEN
			if get_window().mode != Window.MODE_FULLSCREEN
			else Window.MODE_WINDOWED
		)
