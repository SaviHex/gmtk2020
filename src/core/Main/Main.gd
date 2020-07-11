extends Node2D

export(String) var next_level
export(int) var wait_time

onready var timer = $LevelTimer

var paths: Array
var characters: Array

func _ready() -> void:
	timer.wait_time = wait_time
	timer.start()

	self.paths = $EnemyPaths.get_children()
	self.characters = $Characters.get_children()
	init_enemies()

func _physics_process(delta):

	timer.get_node("TimeLeft").bbcode_text = "[right]%s[/right]" % floor(timer.time_left)
	timer.get_node("ProgressBar").value = timer.time_left*100/wait_time

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.scancode == KEY_SPACE and event.is_pressed():
		switcheroo()

func init_enemies():
	var i = 0
	for c in self.characters:
		if c.is_in_group("enemy"):
			c.init(self.paths[i], get_next_char(i))
		i += 1

func get_next_char(i: int) -> Node2D:
	return self.characters[(i + 1) % self.characters.size()]

func switcheroo():
	var i_p = get_player_index()
	var i_e = (get_player_index() + 1) % self.characters.size()

	var p = self.characters[i_p]
	var e = self.characters[i_e]

	e.disable()
	self.characters[i_p] = e
	self.characters[i_e] = p

	var e_pos = e.position
	e.position = p.position
	p.position = e_pos

	# Muda de lugar com o player mas continua mirando no mesmo.
	e.init(self.paths[i_p], get_next_char(i_e))


func get_player_index():
	var i = 0
	for c in self.characters:
		if c.is_in_group("player"):
			return i
		i += 1
	return -1

func _on_Timer_timeout():
	get_tree().change_scene(next_level)
