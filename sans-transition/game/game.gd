extends Node

@export var game_over_scene: PackedScene
@export var mix_table: MixtTable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_scoring_mix_set_finished(score: float) -> void:
	var game_over: GameOverScreen = game_over_scene.instantiate()
	game_over.score = score
	
	add_child(game_over)
	
	mix_table.stop_actions()
	
	#get_tree().change_scene_to_node(game_over)
