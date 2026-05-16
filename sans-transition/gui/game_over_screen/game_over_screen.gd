class_name GameOverScreen
extends Control


@export var score_label: Label
var score: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = str(score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
