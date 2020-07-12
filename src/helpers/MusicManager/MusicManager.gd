extends Node2D

onready var audio_player = $AudioStreamPlayer

func _ready():
	audio_player.play()
