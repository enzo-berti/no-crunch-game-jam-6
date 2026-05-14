extends Node

@export var amplitude: float
@export var rotation_amplitude: float
@export var noise: Noise

var anchor: Vector2
var parent: Node2D

var time: float = 0.0


func _ready() -> void:
	parent = get_parent() as Node2D
	anchor = parent.position

	time = randf() * 8909.0


func _process(delta: float) -> void:
	time += delta
	parent.position = anchor + Vector2(
		noise.get_noise_2d(time, 0.0),
		noise.get_noise_2d(0.0, time),
	) * amplitude
	parent.rotation = noise.get_noise_1d(time + 6756) * rotation_amplitude * PI
