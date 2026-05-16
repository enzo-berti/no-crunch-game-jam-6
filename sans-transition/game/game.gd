extends Node

@export var game_over_scene: PackedScene
@export var scoring: Scoring
@export var base_crowd: Crowd
@export var mix_table: MixtTable


func _ready() -> void:
	
	pass # Replace with function body.


func _process(delta: float) -> void:
	base_crowd.excitement = scoring.get_excitement()


func _on_scoring_mix_set_finished(score: float) -> void:
	var game_over: GameOverScreen = game_over_scene.instantiate()
	game_over.score = score
	
	add_child(game_over)
	
	mix_table.stop_actions()
	
	#get_tree().change_scene_to_node(game_over)
