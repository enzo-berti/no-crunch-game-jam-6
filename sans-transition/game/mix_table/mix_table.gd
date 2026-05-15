class_name MixtTable
extends Node2D

signal track_switched
signal scoring_event(value: float)

@export var synchroniser: Synchroniser
@export var track_list: TrackList

@export var track_visualizer_a: TrackVisualizer
@export var track_visualizer_b: TrackVisualizer

@export var disk_a: Disc
@export var disk_b: Disc

@export var dj_input_left: DJInput
@export var dj_input_right: DJInput

@export var dj_input_mouse: DJInputMouse

@export var sync_button_A: SyncButton
@export var sync_button_B: SyncButton

var next_track_id: int

var track_list_length: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	track_list.track_list.shuffle()
	synchroniser.set_track_public(track_list.track_list[0])
	synchroniser.set_track_dj(track_list.track_list[1])
	update_visualizers()

	dj_input_left.enabled = false
	dj_input_right.enabled = false

	next_track_id = 2

	track_list_length = track_list.track_list.size()

	dj_input_left.input_shifted.connect(synchroniser.speed_updater)
	dj_input_right.input_shifted.connect(synchroniser.speed_updater)


func _process(delta: float) -> void:
	track_visualizer_a.offset = synchroniser.track_A_position_percentage
	track_visualizer_b.offset = synchroniser.track_B_position_percentage

	disk_a.speed = synchroniser.get_track_A_speed() * 0.5
	disk_b.speed = synchroniser.get_track_B_speed() * 0.5

	if synchroniser.is_dj_track_a():
		sync_button_B.state = SyncButton.State.OFF
		sync_button_A.state = (SyncButton.State.SYNCED
			if synchroniser.is_synced
			else SyncButton.State.NOT_SYNCED )
	else:
		sync_button_A.state = SyncButton.State.OFF
		sync_button_B.state = (SyncButton.State.SYNCED
			if synchroniser.is_synced
			else SyncButton.State.NOT_SYNCED )


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("transition") and not event.is_echo() and synchroniser.is_synced:
		if next_track_id == track_list_length:
			next_track_id = 0
			track_list.track_list.shuffle()
			var current_dj_track = synchroniser.get_current_dj_track()
			if current_dj_track == track_list.track_list[0]:
				next_track_id = next_track_id + 1

		dj_input_left.enabled = false
		dj_input_right.enabled = false

		synchroniser.switch_tracks()
		track_switched.emit()
		scoring_event.emit(synchroniser.offset_between_tracks)
		synchroniser.set_track_dj(track_list.track_list[next_track_id])
		update_visualizers()

		next_track_id = next_track_id + 1

	if synchroniser.is_dj_track_a():
		if event.is_action_pressed("listen_dj_track_left"):
			dj_input_left.enabled = true
			synchroniser.enable_DJ_listening()
		if event.is_action_released("listen_dj_track_left"):
			dj_input_left.enabled = false
			synchroniser.disable_DJ_listening()
	else:
		if event.is_action_pressed("listen_dj_track_right"):
			dj_input_right.enabled = true
			synchroniser.enable_DJ_listening()
		if event.is_action_released("listen_dj_track_right"):
			dj_input_right.enabled = false
			synchroniser.disable_DJ_listening()


func update_visualizers() -> void:
	track_visualizer_a.set_track_texture(synchroniser.track_A_data.wave)
	track_visualizer_b.set_track_texture(synchroniser.track_B_data.wave)


func update_tracks(value: float) -> void:
	track_visualizer_b.speed_scale += value
	synchroniser.speed_updater(value)
