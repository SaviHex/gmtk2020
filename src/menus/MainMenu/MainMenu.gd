extends Control

func _ready():
	AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"), 0).cutoff_hz = 20000

func _on_PlayButton_pressed() -> void:
	MusicManager.restart_time()
	SceneTransition.switch_scene(load("res://menus/Tutorial/Tutorial.tscn"))

func _on_ExitButton_pressed() -> void:
	get_tree().quit()
