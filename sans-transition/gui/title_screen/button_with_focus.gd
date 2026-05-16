extends TextureButton

func _ready() -> void:
	focus_entered.connect(
		func(): modulate.v = 1.2
	)

	focus_exited.connect(
		func(): modulate.v = 1.0
	)
