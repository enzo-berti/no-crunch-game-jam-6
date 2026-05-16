extends Node2D

@export var mix_table: MixtTable
@export var scoring_label : Label
@export var ambiance_progress_bar: TextureProgressBar

var current_score: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_score = 0.0

	mix_table.scoring_event.connect(
		func(value:float)->void: 
			compute_score(value)
	)
	
	mix_table.track_switched.connect(reset_ambiance_bar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scoring_label.text = str(current_score).pad_decimals(2)
	
	ambiance_progress_bar.value -= delta
	pass

func reset_ambiance_bar() -> void:
	ambiance_progress_bar.value = ambiance_progress_bar.max_value

func compute_score(offset_window: float) -> void:
	current_score += 500 * (ambiance_progress_bar.max_value - ambiance_progress_bar.value/ambiance_progress_bar.max_value)
