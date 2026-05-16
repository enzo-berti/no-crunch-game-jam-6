extends Node

@export var scoring: Scoring
@export var base_crowd: Crowd
@export var mix_table: MixtTable

@export var game_over: GameOverScreen

func _ready() -> void:
	$Fade.hide()
	game_over.visible = false
	game_over.restart_requested.connect(_on_restart_requested)

func _process(_delta: float) -> void:
	base_crowd.excitement = scoring.get_excitement()


func _on_scoring_mix_set_finished(score: float) -> void:
	mix_table.stop_actions()
	
	await get_tree().create_timer(1.0).timeout
	
	$Fade.show()
	game_over.score = score
	game_over.show()


func _on_restart_requested() -> void:
	get_tree().reload_current_scene()
