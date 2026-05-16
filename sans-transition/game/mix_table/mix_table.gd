class_name MixtTable
extends Node2D

signal track_switched
signal scoring_event(value: float)
signal listen_dj_track
signal shut_dj_track

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

@export var shine_a: Node2D
@export var shine_b: Node2D

@export var highlighter: Highlighter

var is_mixtable_disabled: bool

var next_track_id: int

var track_list_length: int

var can_open_sync_light: bool = true
var can_synchronise: bool = true


func _ready() -> void:
	is_mixtable_disabled = false
	track_list.track_list.shuffle()
	synchroniser.set_track_public(track_list.track_list[0])
	synchroniser.set_track_dj(track_list.track_list[1])
	update_visuals()

	dj_input_left.enabled = false
	dj_input_right.enabled = false

	next_track_id = 2

	track_list_length = track_list.track_list.size()

	dj_input_left.input_shifted.connect(synchroniser.speed_updater)
	dj_input_right.input_shifted.connect(synchroniser.speed_updater)
	
	shine_a.hide()
	shine_b.hide()

func _process(delta: float) -> void:
	if is_mixtable_disabled:
		dj_input_right.enabled = false
		dj_input_left.enabled = false
		return

	track_visualizer_a.offset = synchroniser.track_A_position_percentage
	track_visualizer_b.offset = synchroniser.track_B_position_percentage

	disk_a.speed = synchroniser.get_track_A_speed() * 0.5
	disk_b.speed = synchroniser.get_track_B_speed() * 0.5

	if can_open_sync_light:
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


func transition() -> void:
	if next_track_id == track_list_length:
		next_track_id = 0
		track_list.track_list.shuffle()
		var current_dj_track = synchroniser.get_current_dj_track()
		if current_dj_track == track_list.track_list[0]:
			next_track_id = next_track_id + 1

	dj_input_left.enabled = false
	dj_input_right.enabled = false

	highlighter.vanish()

	synchroniser.switch_tracks()
	track_switched.emit()
	scoring_event.emit(synchroniser.offset_between_tracks)
	synchroniser.set_track_dj(track_list.track_list[next_track_id])
	update_visuals()
	
	shine_a.hide()
	shine_b.hide()

	next_track_id = next_track_id + 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("transition") and not event.is_echo() and synchroniser.is_synced:
		transition()

	if can_synchronise:
		if synchroniser.is_dj_track_a():
			if event.is_action_pressed("listen_dj_track_left"):
				dj_input_left.enabled = true
				synchroniser.enable_DJ_listening()
				highlighter.texture = highlighter.LEFT
				highlighter.appear()
				listen_dj_track.emit()
				shine_a.show()
			
			elif event.is_action_released("listen_dj_track_left"):
				dj_input_left.enabled = false
				highlighter.vanish()
				shine_a.hide()
				synchroniser.disable_DJ_listening()
				shut_dj_track.emit()
		else:
			if event.is_action_pressed("listen_dj_track_right"):
				dj_input_right.enabled = true
				synchroniser.enable_DJ_listening()
				highlighter.texture = highlighter.RIGHT
				highlighter.appear()
				shine_b.show()
				listen_dj_track.emit()

			elif event.is_action_released("listen_dj_track_right"):
				highlighter.vanish()
				shine_b.hide()
				dj_input_right.enabled = false
				synchroniser.disable_DJ_listening()
				shut_dj_track.emit()


func update_visuals() -> void:
	track_visualizer_a.set_track_texture(synchroniser.track_A_data.wave)
	track_visualizer_b.set_track_texture(synchroniser.track_B_data.wave)

	disk_a.set_texture(synchroniser.track_A_data.disc)
	disk_b.set_texture(synchroniser.track_B_data.disc)


func update_tracks(value: float) -> void:
	track_visualizer_b.speed_scale += value
	synchroniser.speed_updater(value)


func _on_tutorial_started() -> void:
	can_open_sync_light = false


func _on_tutorial_ended() -> void:
	track_list.track_list.shuffle()
	synchroniser.set_track_public(track_list.track_list[0])
	synchroniser.set_track_dj(track_list.track_list[1])
	update_visuals()

	dj_input_left.enabled = false
	dj_input_right.enabled = false
	can_open_sync_light = true
	can_synchronise = true


func stop_actions() -> void:
	is_mixtable_disabled = true
	
	var tween: Tween = create_tween()
	tween.tween_method(synchroniser.set_speed, 1.0, 0.01, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
