class_name MixtTable
extends Node2D


@export var synchroniser : Synchroniser
@export var track_list : TrackList
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	synchroniser.set_stream_public(track_list.track_list[0].audio)
	synchroniser.set_stream_dj(track_list.track_list[1].audio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
