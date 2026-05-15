class_name TrackVisualizer
extends Node2D

@export var speed_scale: float = 1.0:
	set(value):
		speed_scale = max(value, 0.0)
		_update_scroll.call_deferred()

@export var track_duration: float = 1.0
@export var bar_scene: PackedScene
@export var bars_per_second: float = 2.0

@export var _track_sprite: Sprite2D
@export var _bars_sprite: Sprite2D

@export var _bar_offset: float = 121

@export var offset: float:
	set(value):
		offset = value
		_update_scroll()

var scroll_speed: float:
	get():
		return _track_sprite.texture.get_size().x / track_duration

const MAX_TRACK_SCALE: int = 5


func _update_scroll() -> void:
	_track_sprite.region_rect.position.x = offset * scroll_speed
	_bars_sprite.region_rect.position.x = offset * scroll_speed


func _process(delta: float) -> void:
	offset += speed_scale * delta
	_update_scroll()


func set_track_texture(texture: Texture2D) -> void:
	_track_sprite.texture = texture
