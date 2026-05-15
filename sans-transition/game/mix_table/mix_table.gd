class_name MixtTable
extends Node2D


@export var synchroniser : Synchroniser
@export var track_list : TrackList

@export var track_visualizer_a: TrackVisualizer
@export var track_visualizer_b: TrackVisualizer

@export var dj_input_left: DJInput
@export var dj_input_right: DJInput

@export var dj_input_mouse : DJInputMouse

@export var sync_button_A : SyncButton
@export var sync_button_B : SyncButton

var next_track_id : int

var track_list_length: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#track_list.track_list.shuffle()
	synchroniser.set_track_public(track_list.track_list[0])
	synchroniser.set_track_dj(track_list.track_list[1])
	update_visualizers()
	
	dj_input_left.enabled = false
	dj_input_right.enabled = true
	
	next_track_id = 2
	
	track_list_length = track_list.track_list.size()
	
	
	
	dj_input_left.input_shifted.connect(
		func(value: float): 
			track_visualizer_a.speed_scale += value
			synchroniser.speed_updater(value)

	)
	
	dj_input_right.input_shifted.connect(
		func(value: float): 
			track_visualizer_b.speed_scale += value
			synchroniser.speed_updater(value)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	synchroniser.calculate_window()
	
	if synchroniser.is_synced:
		if dj_input_right.enabled:
			sync_button_B.state = sync_button_B.State.SYNCED
		else:
			sync_button_A.state = sync_button_A.State.SYNCED
		pass
	else:
		if dj_input_right.enabled:
			sync_button_B.state = sync_button_B.State.NOT_SYNCED
		else:
			sync_button_A.state = sync_button_A.State.NOT_SYNCED

	pass 

func _input(event: InputEvent) -> void:
	#print_debug(event)
	if event.is_action_pressed("transition") and not event.is_echo():		
		if next_track_id == track_list_length: 
			next_track_id = 0
			track_list.track_list.shuffle()
			var current_dj_track = synchroniser.get_current_dj_track()
			if current_dj_track == track_list.track_list[0]:
				next_track_id = next_track_id + 1
		
		print(next_track_id)
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
	

func update_tracks(value: float) -> void:
	track_visualizer_b.speed_scale += value
	synchroniser.speed_updater(value)
	
