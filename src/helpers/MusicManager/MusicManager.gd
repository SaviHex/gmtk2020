extends Node2D

onready var audio_player = $AudioStreamPlayer

var time_start = 0
var time_now = 0
var time_str = ""

func _ready():
	audio_player.play()
	time_start = OS.get_unix_time()
	set_process(true)

func _process(delta):
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	#var minutes = elapsed / 60
	var seconds = elapsed# / 60
	#time_str = "%02d : %02d" % [minutes, seconds]
	time_str = str(seconds)

func restart_time():
	time_start = 0
	time_now = 0
	time_str = ""
	time_start = OS.get_unix_time()
	set_process(true)
