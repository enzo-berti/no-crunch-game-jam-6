extends Node

@export var scoring_label : Label
@export var ambiance_progress_bar: TextureProgressBar

@export var scoring_curve: Curve
@export var max_range: float = 7
var _current_time: float

var current_score: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_score = 0.0
	
	reset_ambiance_bar()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t: float = 1-(_current_time/max_range)
	print(t)
	
	current_score += scoring_curve.sample(t) * delta
	
	_current_time -= delta
	_current_time = max(_current_time,0)
	
	update_ui()

func reset_ambiance_bar() -> void:
	_current_time = max_range
	
func update_ui() -> void:
	var t: float = _current_time/max_range
	ambiance_progress_bar.value = t
	scoring_label.text = str(floori(current_score))
	


func _on_mix_table_track_switched() -> void:
	reset_ambiance_bar()
