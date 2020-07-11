extends Node2D

export(String) var next_level
export(int) var wait_time

onready var timer = get_node("Timer")
onready var time_left_label = get_node("Timer/TimeLeft")

var paths: Array
var characters: Array

func _ready() -> void:
	timer.wait_time = wait_time
	timer.start()
	
	self.paths = $EnemyPaths.get_children()
	self.characters = $Characters.get_children()
	init_enemies()

func _physics_process(delta):
	time_left_label.set_text(str(floor(timer.time_left)))

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
	var i = 0
	for c in self.characters:
		if c.is_in_group("enemy"):
			c.disable()
		c.position = get_next_char(i).position
		i += 1

	var front_char = self.characters.pop_front()
	self.characters.push_back(front_char)

	init_enemies()

func _on_Timer_timeout():
	get_tree().change_scene(next_level)
