@tool
extends PointLight2D

func _ready() -> void:
	scale = Vector2.ZERO
	await get_tree().create_timer(randf_range(1.0, 2.6)).timeout
	spawn()


func spawn() -> void:
	position = Vector2(randf_range(0.0, 1920), randf_range(0.0, 1000))
	color.h = randf()
	scale = Vector2.ONE * randf_range(0.5, 1.0)
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)

	var duration: float = randf_range(1.0, 2.6)

	var target: float = randf_range(1.0, 5.5)
	tween.tween_property(self, "energy", target, duration).from(0.0)
	tween.tween_property(self, "energy", 0.0, duration).from(target)

	await get_tree().create_timer(duration * 2.1).timeout
	spawn()
