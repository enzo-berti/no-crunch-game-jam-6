
@tool
class_name SyncButton
extends Node2D

enum State {
	OFF,
	NOT_SYNCED,
	SYNCED,
}

@export var sprite: Sprite2D

@export var state: State:
	set(value):
		state = value
		_update_state.call_deferred()


@export var texture_off: Texture2D
@export var texture_not_synced: Texture2D
@export var texture_synced: Texture2D

func _update_state() -> void:
	match state:
		State.OFF:
			sprite.texture = texture_off
		State.NOT_SYNCED:
			sprite.texture = texture_not_synced
		State.SYNCED:
			sprite.texture = texture_synced
