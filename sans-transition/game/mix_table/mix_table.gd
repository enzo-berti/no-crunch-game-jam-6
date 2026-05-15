class_name MixtTable
extends Node2D


@export var synchroniser : Synchroniser
@export var track_list : TrackList

@export var track_visualizer_a: TrackVisualizer
@export var track_visualizer_b: TrackVisualizer

@export var dj_input_left: DJInput
@export var dj_input_right: DJInput

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	synchroniser.set_stream_public(track_list.track_list[0].audio)
	synchroniser.set_stream_dj(track_list.track_list[1].audio)
	
	
	dj_input_left.input_shifted.connect(
		func(value: float): track_visualizer_a.speed_scale += value
	)
	
	dj_input_right.input_shifted.connect(
		func(value: float): track_visualizer_b.speed_scale += value
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func _input(event: InputEvent) -> void:
	if event.is_action("transition"):
		synchroniser.calculate_window()
	pass
