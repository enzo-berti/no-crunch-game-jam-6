class_name Scoring
extends Node



@export_group("Mix Set")
@export var total_mix_set_time_seconds: float
@export var total_track_time_pb: TextureProgressBar


@export_group("Scoring")
@export var scoring_label : Label
@export var scoring_curve: Curve
@export var max_range_scoring: float = 7


var _track_time: float



signal mix_set_finished(score: float)

var excitment: float 

var _scoring_time: float

var current_score: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_score = 0.0
	total_track_time_pb.max_value = total_mix_set_time_seconds
	_track_time = total_mix_set_time_seconds
	
	reset_excitement()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _track_time <= 0:
		mix_set_finished.emit(current_score)
		set_process(false)
	
	var t: float = 1-excitment
	
	current_score += scoring_curve.sample(t) * delta
	
	_scoring_time -= delta
	_track_time -= delta

	_scoring_time = max(_scoring_time,0)
	
	update_ui()
	


func reset_excitement() -> void:
	_scoring_time = max_range_scoring
	
func update_ui() -> void:
	excitment = _scoring_time/max_range_scoring
	total_track_time_pb.value = _track_time
	scoring_label.text = str(floori(current_score))
	


func _on_mix_table_track_switched() -> void:
	reset_excitement()

func get_excitement() -> float:
	return excitment
