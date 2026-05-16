@tool
class_name PeopleLayer extends Sprite2D

@export var jump_height: float
@export var jump_amount: float
@export var jump_scale: float


func _process(delta: float) -> void:
	position.y = -jump_height * jump_amount * jump_scale
