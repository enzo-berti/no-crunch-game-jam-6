@tool
class_name TrackVisualizer
extends Node2D

@export var _track_sprite: Sprite2D
@export var _bars_sprite: Sprite2D

@export var _bar_offset: float = 121

@export var offset: float:
	set(value):
		offset = value
		if is_node_ready():
			_update_scroll()

const MAX_TRACK_SCALE: int = 5


func _update_scroll() -> void:
	_track_sprite.region_rect.position.x = offset * _track_sprite.texture.get_size().x
	_bars_sprite.region_rect.position.x = offset * _track_sprite.texture.get_size().x + _bar_offset


func set_track_texture(texture: Texture2D) -> void:
	_track_sprite.texture = texture
