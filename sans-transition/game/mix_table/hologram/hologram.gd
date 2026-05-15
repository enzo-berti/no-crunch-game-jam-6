@tool
extends Node2D

@export var audio_stream_player: AudioStreamPlayer
@export var icon: Node2D

@export var input_action: InputEventAction

@export_tool_button("Play") var _play_debug: Callable = play

var _tween: Tween


func _input(event: InputEvent) -> void:
	if input_action.is_match(event) and event.is_pressed() and not event.is_echo():
		play()


func play() -> void:
	audio_stream_player.play()
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(icon, "scale", Vector2.ONE, 1.0) \
	.from(Vector2.ONE * 2.0).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
