class_name Disc
extends Node2D

@export var mesh_instance_2d: MeshInstance2D
@export var direction: float

var speed: float = 1.0
var _angle: float = 0.0


func set_texture(texture: Texture2D) -> void:
	mesh_instance_2d.texture = texture


func _process(delta: float) -> void:
	_angle += speed * delta * TAU * sign(direction)
	(mesh_instance_2d.material as ShaderMaterial).set_shader_parameter(&"angle", _angle)
