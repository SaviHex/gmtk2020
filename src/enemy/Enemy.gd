extends KinematicBody2D

var speed = 50
var friction = 0.2
var acceleration = 0.5
var velocity = Vector2.ZERO

onready var pivot = get_node("Pivot")
onready var bullet_point = get_node("Pivot/BulletPoint")

var bullet = preload("res://bullet/Bullet.tscn")

var path_positions = Array()
var current_pos : int = 0

func _ready():
	var path_node_parent
	for node in get_parent().get_parent().get_node("Characters/AiPath").get_children():
		if node.get_name() == get_name():
			path_node_parent = node
			break
	
	for node in path_node_parent.get_children():
		path_positions.append(node)

func get_target():
	var target_pos = path_positions[current_pos].position
	if abs(target_pos.y - position.y) < 10 and abs(target_pos.x - position.x) < 10:
			current_pos += 1
			if current_pos > path_positions.size() - 1:
				current_pos = 0
	return target_pos

func _physics_process(delta):
	var target_pos = get_target()
	var input_velocity = Vector2.ZERO
	
	if target_pos:
		pivot.look_at(target_pos)
		input_velocity = (target_pos - position).normalized() * speed
		
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)	

func shoot():
	var b = bullet.instance()
	b.start(bullet_point.global_position, pivot.rotation)
	get_parent().add_child(b)
