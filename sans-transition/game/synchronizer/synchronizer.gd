class_name Synchroniser
extends Node

signal tracks_in_range_signal(in_range: bool)

@export_group("Settings")
@export var offset_window: float
@export var speed_window: float
@export var required_sync_duration: float = 0.3

var track_A_position_percentage: float
var track_A_position_modulo: float
var track_A_speed: float
var track_A_length: float

var track_B_speed: float
var track_B_position_percentage: float
var track_B_length: float
var track_B_position_modulo: float

var track_A_data: TrackData
var track_B_data: TrackData

@export_group("Depenencies")
@export var audio_stream_player_track_A: AudioStreamPlayer
@export var audio_stream_player_track_B: AudioStreamPlayer
var audio_stream_player_public: AudioStreamPlayer
var audio_stream_player_dj_only: AudioStreamPlayer

@export_group("Effects")
@export_subgroup("Public")

@export var public_filter: AudioEffectFilter
@export var public_panner: AudioEffectPanner
@export var public_reverb: AudioEffectReverb

@export_subgroup("DJ")

@export var djonly_panner: AudioEffectPanner

@export_subgroup("Tweaks")

@export var cuttof_value_enable: int
@export var cuttof_value_disable: int

var offset_between_tracks: float

var is_synced: bool

@onready var public_bus_id: int = AudioServer.get_bus_index("Public")
@onready var dj_bus_id: int = AudioServer.get_bus_index("DjOnly")

## Duration for which the track are synced
var _sync_duration: float = 0.0

func _ready() -> void:
	# init des stream public et dj pour gestion des panner
	audio_stream_player_public = audio_stream_player_track_A
	audio_stream_player_dj_only = audio_stream_player_track_B

	audio_stream_player_dj_only.pitch_scale = randf_range(0.2, 4)
	is_synced = false
	public_reverb.hipass = 0.3

func _process(delta: float) -> void:
	if audio_stream_player_track_A.stream == null or audio_stream_player_track_B.stream == null:
		return

	track_A_length = audio_stream_player_track_A.stream.get_length()
	track_B_length = audio_stream_player_track_B.stream.get_length()

	track_A_position_percentage = audio_stream_player_track_A.get_playback_position() / track_A_length
	track_B_position_percentage = audio_stream_player_track_B.get_playback_position() / track_B_length

	if check_sychroniation():
		_sync_duration += delta
	else:
		_sync_duration = 0.0
		if is_synced:
			is_synced = false
			tracks_in_range_signal.emit(false)
	
	if _sync_duration >= required_sync_duration:
		if not is_synced:
			tracks_in_range_signal.emit(true)
			is_synced = true

func enable_DJ_listening() -> void:
	audio_stream_player_dj_only.set_volume_db(0)
	if audio_stream_player_track_A == audio_stream_player_public:
		public_panner.pan = -1
		djonly_panner.pan = 1

	else:
		public_panner.pan = 1
		djonly_panner.pan = -1

	public_filter.cutoff_hz = cuttof_value_enable


func disable_DJ_listening() -> void:
	public_panner.pan = 0
	audio_stream_player_dj_only.set_volume_db(-80)
	public_filter.cutoff_hz = cuttof_value_disable


func switch_tracks() -> void:
	var previous_public_track: AudioStreamPlayer
	previous_public_track = audio_stream_player_public
	audio_stream_player_public = audio_stream_player_dj_only
	audio_stream_player_dj_only = previous_public_track

	audio_stream_player_public.bus = "Public"
	audio_stream_player_public.volume_db = 0
	audio_stream_player_public.pitch_scale = 1

	audio_stream_player_dj_only.bus = "DjOnly"
	audio_stream_player_dj_only.volume_db = -80
	audio_stream_player_dj_only.pitch_scale = randf_range(0, 4)

	public_panner.pan = 0
	djonly_panner.pan = 0
	public_filter.cutoff_hz = cuttof_value_disable


## Checks if the track are currently synchronized (on this frame)
func check_sychroniation() -> bool:
	track_A_position_modulo = fmod(track_A_position_percentage * 4, 1)
	track_B_position_modulo = fmod(track_B_position_percentage * 4, 1)

	if abs(audio_stream_player_dj_only.pitch_scale - 1.0) < speed_window:
		var difference_in_mesure = abs(track_A_position_modulo - track_B_position_modulo)
		var difference_out_mesure: float = 0.0

		if track_A_position_modulo > track_B_position_modulo:
			difference_out_mesure = abs(-(1.0 - track_A_position_modulo))
		else:
			difference_out_mesure = abs(-(1.0 - track_B_position_modulo))

		offset_between_tracks = min(difference_in_mesure, difference_out_mesure)

		return offset_between_tracks < offset_window
		
	else:
		return false
	

func set_track_public(data: TrackData) -> void:
	if audio_stream_player_public == audio_stream_player_track_A:
		track_A_data = data
	else:
		track_B_data = data

	audio_stream_player_public.stop()
	audio_stream_player_public.stream = data.audio
	audio_stream_player_public.play()


func set_track_dj(data: TrackData) -> void:
	if audio_stream_player_dj_only == audio_stream_player_track_A:
		track_A_data = data
	else:
		track_B_data = data

	audio_stream_player_dj_only.stop()
	audio_stream_player_dj_only.stream = data.audio
	audio_stream_player_dj_only.play()


func speed_updater(value: float) -> void:
	audio_stream_player_dj_only.pitch_scale += value


## Is the DJ only track the track A ?
func is_dj_track_a() -> bool:
	return audio_stream_player_dj_only == audio_stream_player_track_A


func get_track_A_speed() -> float:
	return audio_stream_player_track_A.pitch_scale


func get_track_B_speed() -> float:
	return audio_stream_player_track_B.pitch_scale


func get_offset_between_tracks() -> float:
	return offset_between_tracks


func get_current_dj_track() -> TrackData:
	if audio_stream_player_track_A == audio_stream_player_dj_only:
		return track_A_data
	else:
		return track_B_data

func set_speed(speed_value: float) -> void:
	#tween pour decrement de la valeur
	audio_stream_player_dj_only.pitch_scale = speed_value
	audio_stream_player_public.pitch_scale = speed_value
	pass
	
