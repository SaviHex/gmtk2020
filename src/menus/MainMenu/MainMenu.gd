extends Control

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://core/Main/Main.tscn")

func _on_ExitButton_pressed() -> void:
	get_tree().quit()
