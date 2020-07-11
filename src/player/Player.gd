extends KinematicBody2D

var speed = 150
var friction = 0.2
var acceleration = 0.5
var velocity = Vector2.ZERO

onready var pivot = get_node("Pivot")
onready var bullet_point = get_node("Pivot/BulletPoint")

var bullet = preload("res://bullet/Bullet.tscn")

func get_inputs():
	var input_velocity = Vector2.ZERO
	
	# Movement Input
	if Input.is_action_pressed("right"):
		input_velocity.x += 1
	if Input.is_action_pressed("left"):
		input_velocity.x -= 1
	if Input.is_action_pressed("down"):
		input_velocity.y += 1
	if Input.is_action_pressed("up"):
		input_velocity.y -= 1
	input_velocity = input_velocity.normalized() * speed
	
	# Shooting input
	if Input.is_action_just_pressed('mouse_click'):
		shoot()
	
	return input_velocity

func get_target():
	return get_global_mouse_position()

func _physics_process(delta):
	
	pivot.look_at(get_target())
	
	var input_velocity = get_inputs()
	
	# If there's input, accelerate to the input velocity
	if input_velocity.length() > 0:
		velocity = velocity.linear_interpolate(input_velocity, acceleration)
	else:
		# If there's no input, slow down to (0, 0)
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction)
	velocity = move_and_slide(velocity)

func shoot():
	var b = bullet.instance()
	b.start(bullet_point.global_position, pivot.rotation)
	get_parent().add_child(b)
