extends Control

@export var tween_intensity: float
@export var tween_duration: float

@export var sfx_button_pressed: AudioStreamPlayer2D
@export var buttons: Array[BaseButton]

@export var credits_scene: Control

func _process(_delta: float) -> void:
	for button in buttons:
		btn_hovered(button)

func start_tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: BaseButton):
	button.pivot_offset = button.size / 2.0
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)


func _on_start_button_pressed() -> void:
	sfx_button_pressed.play()
	
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_packed(load("uid://c8mtky32erftq"))

func _on_credits_button_pressed() -> void:
	credits_scene.visible = true
