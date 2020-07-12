extends Control

func _physics_process(delta):
	MusicManager.time_str
	var time_text = "[center]\"What are you kids doing?? I leave for just [color=#d95763]" + MusicManager.time_str + "[/color] seconds and you are already messing with the interdimentional guns!\"[/center]"
	$Title.bbcode_text = time_text

func _on_ExitButton_pressed():
	SceneTransition.switch_scene(load("res://menus/MainMenu/MainMenu.tscn"))
