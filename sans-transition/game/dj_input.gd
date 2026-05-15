class_name DJInput
extends Node

var enabled: bool = false
enum InputSide {
	LEFT = 0,
	RIGHT = 1,
}

@export var input_side: InputSide = InputSide.LEFT

@export var sensibility_threshold: float = 0.01
@export var multiplier: float = 0.1
var _last_input_vector: Vector2
var _has_last_input: bool = false

var turns: float = 0.0

signal input_shifted(value: float)


func _process(delta: float) -> void:
	var input_vector := (
		Input.get_vector("left_platine_left", "left_platine_right", "left_platine_down", "left_platine_up")
		if input_side == InputSide.LEFT 
		else Input.get_vector("right_platine_left", "right_platine_right", "right_platine_down", "right_platine_up")
	)

	if not input_vector.is_zero_approx():
		if not _has_last_input:
			_last_input_vector = input_vector

		_has_last_input = true
		var angle: float = input_vector.angle_to(_last_input_vector)
		var factor: float = angle / PI
		if abs(factor) > sensibility_threshold:
			input_shifted.emit(factor * multiplier)
			_last_input_vector = input_vector
		turns += factor
		print(turns)
	else:
		_has_last_input = false
