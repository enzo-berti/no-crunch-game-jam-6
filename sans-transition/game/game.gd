extends Node

@export var game_over_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_scoring_mix_set_finished(score: float) -> void:
	var game_over: GameOverScreen = game_over_scene.instantiate()
	game_over.score = score
	
	get_tree().change_scene_to_node(game_over)
	pass # Replace with function body.
