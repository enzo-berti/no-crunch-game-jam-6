class_name GameOverScreen
extends Control

signal restart_requested

@export var score_label: Label
var score: int:
	set(value):
		score = value
		score_label.text = str(score)

func _on_start_button_pressed() -> void:
	restart_requested.emit()
