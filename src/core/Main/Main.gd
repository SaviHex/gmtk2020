extends Node2D

export(PackedScene) var next_level
export(int) var wait_time
export(String) var level_name

onready var timer = $LevelTimer

var paths: Array
var characters: Array

func _ready() -> void:
	AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"), 0).cutoff_hz = 20000
	
	self.paths = $EnemyPaths.get_children()
	self.characters = $Characters.get_children()
	init_characters()
	
	yield(get_tree().create_timer(.1), "timeout")
	
	timer.wait_time = wait_time
	timer.start()
	
	start_level()

func _physics_process(delta):

	timer.get_node("TimeLeft").bbcode_text = "[right]%s[/right]" % floor(timer.time_left)
	timer.get_node("ProgressBar").value = timer.time_left*100/wait_time
#
#func _input(event: InputEvent) -> void:
#	if event is InputEventKey and event.scancode == KEY_SPACE and event.is_pressed():
#		switcheroo()

func init_characters():
	var i = 0
	for c in self.characters:

		if c.is_in_group("enemy"):
			c.init(self.paths[i], get_next_char(i))

		if c.is_in_group("player"):
			pass # Qualquer inicialização necessária pro player aqui...

		c.connect("shot", self, "_on_Character_shot")
		c.connect("got_shot", self, "_on_Character_got_shot")

		i += 1

func get_next_char(i: int) -> Node2D:
	return self.characters[(i + 1) % self.characters.size()]

func switcheroo():
	var i_p = get_player_index()
	var i_e = (get_player_index() + 1) % self.characters.size()

	var p = self.characters[i_p]
	var e = self.characters[i_e]

	self.paths[i_e].color = Color.transparent
	self.paths[i_p].color = e.path_color

	e.disable()
	self.characters[i_p] = e
	self.characters[i_e] = p

	# pause
	get_tree().paused = true
	p.pause()

	get_node("Sounds/Teleporting").play()

	# play animation before the switch
	p.play_anim_before_teleport()
	e.play_anim_before_teleport()
	yield(get_tree().create_timer(1), "timeout")

	p.position = e.position
	
	var too_close = true
	var count = 0
	var dist
	var dist_min = 50
	
	while too_close:
		count += 1
		if count > 30:
			break
		e.position = self.paths[i_p].get_current_point()
		too_close = false
		for b in get_tree().get_nodes_in_group("bullet"):
			dist = sqrt(pow(b.position.x - e.position.x, 2) + pow(b.position.y - e.position.y, 2))
			if dist < dist_min:
				too_close = true
				break
		if too_close:
			self.paths[i_p].advance(10)

	# play animation after the switch
	p.play_anim_after_teleport()
	e.play_anim_after_teleport()
	yield(get_tree().create_timer(1), "timeout")

	# unpause
	p.unpause()
	get_tree().paused = false

	e.current_path.color = Color.transparent
	# Muda de lugar com o player mas continua mirando no mesmo.
	if self.characters.size() == 2:
		e.init(self.paths[i_p], p)
	else:
		e.init(self.paths[i_p], get_next_char(i_e))

func get_player_index():
	var i = 0
	for c in self.characters:
		if c.is_in_group("player"):
			return i
		i += 1
	return -1

func start_level():
	get_tree().paused = true
	get_node("Characters/Player").pause()
	
	get_node("AnimationLabels/LevelTitle").bbcode_text = "[center][wave]%s[/wave][/center]" % level_name
	get_node("AnimationLabels/CountDownGameOver").bbcode_text = "[center][wave]3[/wave][/center]"
	yield(get_tree().create_timer(1), "timeout")
	get_node("AnimationLabels/CountDownGameOver").bbcode_text = "[center][wave]2[/wave][/center]"
	yield(get_tree().create_timer(1), "timeout")
	get_node("AnimationLabels/CountDownGameOver").bbcode_text = "[center][wave]1[/wave][/center]"
	yield(get_tree().create_timer(1), "timeout")
	get_node("AnimationLabels/CountDownGameOver").bbcode_text = "[center][wave]GO![/wave][/center]"
	yield(get_tree().create_timer(.5), "timeout")
	get_node("AnimationLabels/CountDownGameOver").bbcode_text = ""
	get_node("AnimationLabels/LevelTitle").bbcode_text = ""
	
	get_node("Characters/Player").unpause()
	get_tree().paused = false

func game_over():
	AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"), 0).cutoff_hz = 2000
	for c in self.characters:
		c.set_sprite(1)
	get_node("Sounds/GameOver").play()
	get_node("Characters/Player").pause()
	get_tree().paused = true
	
	get_node("AnimationLabels/CountDownGameOver").bbcode_text = "[center][shake]Game Over[/shake][/center]"
	yield(get_tree().create_timer(2), "timeout")
	#get_tree().paused = false
	SceneTransition.reload_scene()

func _on_Timer_timeout():
	SceneTransition.switch_scene(next_level)

func _on_Character_got_shot() -> void:
	$Camera2D.shake(0.2, 15, 8)
	game_over()

func _on_Character_shot() -> void:
	$Camera2D.shake(0.2, 10, 4)
	switcheroo()
