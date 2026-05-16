extends Control

@export var sfx_button_pressed: AudioStreamPlayer
@export var buttons: Array[BaseButton]

@export var credits_scene: Credits

func _ready() -> void:
	buttons.append(credits_scene.x_button)

func _process(_delta: float) -> void:
	for button in buttons:
		btn_hovered(button)

func start_tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: BaseButton):
	button.pivot_offset = button.size / 2.0
	if button.is_hovered():
		if (button.scale >= Vector2.ONE * 1.3):
			start_tween(button, "scale", Vector2.ONE * 1.2, 0.05)
		elif (button.scale <= Vector2.ONE * 1.2):
			start_tween(button, "scale", Vector2.ONE * 1.3, 0.3)
	else:
		start_tween(button, "scale", Vector2.ONE, 0.2)


func _on_start_button_pressed() -> void:
	sfx_button_pressed.play()
	
	$Loading.show()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("uid://cq3inuaup1vaf")

func _on_credits_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(credits_scene, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_IN_OUT)


func _on_quit_button_pressed() -> void:
	get_tree().quit() 
