extends Node2D
class_name Tutorial

@export var mix_table: MixtTable

@export var sync_button: Node2D

signal started
signal sync_button_started
signal ended

var can_synced: bool = false
var has_suceed_track: bool = false
var has_suceed_synced: bool = false
var flashes: bool = false

var sync_button_timer: float = 0.0
var sync_button_time: float = 0.5

func _ready() -> void:
	started.emit()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("transition") && !event.is_echo() && has_suceed_synced:
		mix_table.transition()


func _process(delta: float) -> void:
	if (flashes):
		mix_table.sync_button_A.state = SyncButton.State.OFF
		flashes_sync_button(delta, mix_table.sync_button_B, SyncButton.State.NOT_SYNCED)
	
	# HAS SUCEED TO SYNCHRONISE
	if (can_synced && mix_table.synchroniser.is_synced):
		mix_table.can_open_sync_light = false
		mix_table.dj_input_left.enabled = false
		mix_table.dj_input_right.enabled = false
		mix_table.highlighter.vanish()
		has_suceed_synced = true
		can_synced = false
		sync_button.visible = true
	
	if (has_suceed_synced):
		flashes_sync_button(delta, mix_table.sync_button_B, SyncButton.State.SYNCED)


func flashes_sync_button(delta: float, sync_button: SyncButton, state: SyncButton.State) -> void:
	sync_button_timer += delta
	if (sync_button_timer >= sync_button_time):
		sync_button_timer -= sync_button_time
		sync_button.state = (SyncButton.State.OFF
			if sync_button.state == state
			else state)


func _on_mix_table_track_switched() -> void:
	has_suceed_track = true
	ended.emit()
	queue_free()


func _on_mix_table_listen_dj_track() -> void:
	flashes = false
	mix_table.can_synchronise = false
	mix_table.can_open_sync_light = true
	can_synced = true
	sync_button.visible = false


func _on_started() -> void:
	sync_button_started.emit()
	flashes = true
	sync_button.visible = true
