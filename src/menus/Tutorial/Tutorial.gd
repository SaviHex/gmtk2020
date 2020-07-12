extends Control

func _on_ExitButton_pressed():
	MusicManager.restart_time()
	SceneTransition.switch_scene(load("res://levels/Level1.tscn"))
