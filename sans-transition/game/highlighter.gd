class_name Highlighter
extends Sprite2D

const LEFT = preload("uid://dw84npleexnb0")
const RIGHT = preload("uid://dg8h8ulwi3vyx")

@export var duration: float = 0.1

var _tween: Tween

func appear() -> void:
	transition(1.0)


func vanish() -> void:
	transition(0.0)


func transition(to: float) -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	
	_tween.tween_property(
		material as ShaderMaterial, ^"shader_parameter/factor", to, duration
	).from_current().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
