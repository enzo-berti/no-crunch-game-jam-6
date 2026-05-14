class_name Track_Synchroniser
extends Node


signal tracks_in_range_signal(in_range: bool)

@export var offset_window : float

@export var track_A_position_percentage: float
@export var track_A_position_modulo: float
@export var track_A_speed : float
@export var track_A_length : float

@export var track_B_speed : float
@export var track_B_position_percentage: float
@export var track_B_length : float
@export var track_B_position_modulo: float

@export var audio_stream_player_track_A : AudioStreamPlayer
@export var audio_stream_player_track_B : AudioStreamPlayer
var audio_stream_player_public : AudioStreamPlayer
var audio_stream_player_dj_only : AudioStreamPlayer


@export var public_filter : AudioEffectFilter
@export var public_panner : AudioEffectPanner

@export var djonly_filter : AudioEffectFilter
@export var djonly_panner : AudioEffectPanner

@export var cuttof_value_enable: int
@export var cuttof_value_disable : int

@onready var public_bus_id : int = AudioServer.get_bus_index("Public")
@onready var dj_bus_id : int = AudioServer.get_bus_index("DjOnly")

@export var sync_state : bool
var previous_sync_state : bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# init des stream public et dj pour gestion des panner
	audio_stream_player_public = audio_stream_player_track_A
	audio_stream_player_dj_only = audio_stream_player_track_B
	
	track_A_length = audio_stream_player_track_A.stream.get_length()
	track_B_length = audio_stream_player_track_B.stream.get_length()
	
	sync_state = false
	previous_sync_state = false
	
	audio_stream_player_track_A.play();
	audio_stream_player_track_B.play();
	
	
	await get_tree().create_timer(5).timeout
	enable_DJ_listening()
	await get_tree().create_timer(5).timeout
	disable_DJ_listening()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	track_A_position_percentage = audio_stream_player_track_A.get_playback_position() / track_A_length
	track_B_position_percentage = audio_stream_player_track_B.get_playback_position() / track_B_length
		
	calculate_window()
	pass
	

func enable_DJ_listening() -> void :
	if audio_stream_player_track_A == audio_stream_player_public:
		public_panner.pan = -1
		djonly_panner.pan = 1

	else:
		public_panner.pan = 1
		djonly_panner.pan = -1
		
	public_filter.cutoff_hz = cuttof_value_enable
	audio_stream_player_dj_only.set_volume_db(0)


func disable_DJ_listening() -> void :
	public_panner.pan = 0
	audio_stream_player_dj_only.set_volume_db(-80)
	public_filter.cutoff_hz = cuttof_value_disable

func switch_tracks() -> void : 
	var previous_public_track : AudioStreamPlayer
	previous_public_track = audio_stream_player_public
	audio_stream_player_public = audio_stream_player_dj_only
	audio_stream_player_dj_only = previous_public_track
	
func calculate_window() -> void :
	
	track_A_position_modulo = fmod(track_A_position_percentage * 4, 1)
	track_B_position_modulo = fmod(track_B_position_percentage * 4, 1)
	
	var difference_in_mesure = abs(track_A_position_modulo - track_B_position_modulo)
	var difference_out_mesure : int
	if track_A_position_modulo > track_B_position_modulo: 
		difference_out_mesure = 1 - track_A_position_modulo
	else:
		difference_out_mesure = 1 - track_B_position_modulo
	
	var difference_to_check = min(difference_in_mesure,difference_out_mesure)
	
	
	if difference_to_check < offset_window and !sync_state:
		tracks_in_range_signal.emit(true)
		sync_state = true
		print_debug("in Range")
	elif difference_to_check > offset_window and sync_state:
		tracks_in_range_signal.emit(false)
		sync_state = false
		print_debug("out Range")
	
