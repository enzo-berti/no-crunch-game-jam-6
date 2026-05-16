class_name GameOverScreen
extends Control

signal restart_requested

@export var score_label: Label
var score: int


func _ready() -> void:
	score_label.text = str(score)


func _on_start_button_pressed() -> void:
	restart_requested.emit()
