extends Control

var current_slide: int = 0

signal finished

func _ready() -> void:
	update_slides()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		current_slide += 1
		if current_slide >= get_child_count():
			finished.emit()
			queue_free()
		else:
			update_slides()


## Horrible I want to KMS
func update_slides():
	for c: Control in get_children():
		c.hide()

	get_child(current_slide).show()
