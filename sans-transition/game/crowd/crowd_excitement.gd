@tool
class_name Crowd
extends Node

@export var excitement: float:
	set(value):
		excitement = value
		_update_excitement.call_deferred()
		
@export var track: TrackData

@export var animations: Array[AnimatedSprite2D]
@export var animationPlayer: AnimationPlayer

@export var crowd_layers: Array[PeopleLayer]

func _update_excitement() -> void:
	for c in crowd_layers:
		c.jump_scale = 0.1 + excitement

func _on_tutorial_ended() -> void:
	self.visible = true
