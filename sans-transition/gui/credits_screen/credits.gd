extends Control
class_name Credits

signal quitted

@export var x_button: BaseButton

func _on_x_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.1).set_ease(Tween.EASE_OUT_IN)
	quitted.emit()
