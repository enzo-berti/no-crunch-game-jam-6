extends Node

@export var track: TrackData

@export var animations: Array[AnimatedSprite2D]
@export var animationPlayer: AnimationPlayer

func _ready() -> void:
	for animation in animations:
		animation.play()
		var x: float = randf() * 1700 + 100
		animation.position.x = x
	
	animationPlayer.play("crowd")
	
	_on_bpm_changed(2)


func _process(delta: float) -> void:
	pass

func _on_bpm_changed(bpm: float) -> void:
	for animation in animations:
		animation.speed_scale = bpm
	
	animationPlayer.speed_scale = bpm
