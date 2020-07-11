extends CanvasLayer

onready var anim: AnimationPlayer = $AnimationPlayer

func switch_scene(scene: PackedScene, animation: String = "v_curtains"):
	set_visuals(true)
	self.anim.play(animation)
	yield(anim, "animation_finished")
	get_tree().change_scene_to(scene)
	self.anim.play_backwards(animation)
	yield(self.anim, "animation_finished")
	set_visuals(false)

func reload_scene(animation: String = "v_curtains"):
	set_visuals(true)
	self.anim.play(animation)
	yield(self.anim, "animation_finished")
	get_tree().reload_current_scene()
	self.anim.play_backwards(animation)
	yield(self.anim, "animation_finished")
	set_visuals(false)

func set_visuals(visible: bool):
	$Top.visible = visible
	$Bottom.visible = visible
