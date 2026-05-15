class_name MixtTable
extends Node2D


@export var synchroniser : Synchroniser
@export var track_list : TrackList

@export var track_visualizer_a: TrackVisualizer
@export var track_visualizer_b: TrackVisualizer

@export var dj_input_left: DJInput
@export var dj_input_right: DJInput

@export var dj_input_mouse : DJInputMouse

var next_track_id : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	synchroniser.set_track_public(track_list.track_list[0])
	synchroniser.set_track_dj(track_list.track_list[1])
	update_visualizers()
	
	dj_input_left.enabled = false
	dj_input_right.enabled = true
	
	next_track_id = 2
	
	dj_input_left.input_shifted.connect(synchroniser.speed_updater)
	dj_input_right.input_shifted.connect(synchroniser.speed_updater)


func _process(delta: float) -> void:
	synchroniser.calculate_window()
	track_visualizer_a.offset = synchroniser.track_A_position_percentage
	track_visualizer_b.offset = synchroniser.track_B_position_percentage


func _input(event: InputEvent) -> void:
	#print_debug(event)
	if event.is_action_pressed("transition") and not event.is_echo():
		synchroniser.switch_tracks()
		synchroniser.set_track_dj(track_list.track_list[next_track_id])
		update_visualizers()
		
		next_track_id = next_track_id + 1
		
		dj_input_left.enabled = !dj_input_left.enabled
		dj_input_right.enabled = !dj_input_right.enabled
		
	elif event.is_action_pressed("listen_dj_track_right") and dj_input_right.enabled:
		synchroniser.enable_DJ_listening()
	elif event.is_action_released("listen_dj_track_right") and dj_input_right.enabled:
		synchroniser.disable_DJ_listening()
	elif event.is_action_pressed("listen_dj_track_left") and dj_input_left.enabled:
		synchroniser.enable_DJ_listening()
	elif event.is_action_released("listen_dj_track_left") and dj_input_left.enabled:
		synchroniser.disable_DJ_listening()
		
		
func update_visualizers() -> void:
	track_visualizer_a.set_track_texture(synchroniser.track_A_data.wave)
	track_visualizer_b.set_track_texture(synchroniser.track_B_data.wave)
