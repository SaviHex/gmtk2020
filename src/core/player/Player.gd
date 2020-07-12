extends KinematicBody2D

signal shot
signal got_shot

var speed = 80
var friction = 0.2
var acceleration = 0.5
var velocity = Vector2.ZERO

export var bullet_speed: float = 300

onready var pivot = get_node("Pivot")
onready var bullet_point = get_node("Pivot/BulletPoint")

var bullet = preload("res://core/bullet/Bullet.tscn")

var paused : bool = false

func pause():
	paused = true

func unpause():
	paused = false

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

	if paused:
		return

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
	b.start(bullet_point.global_position, pivot.rotation, bullet_speed)
	get_parent().add_child(b)
	emit_signal("shot")
	$Shooting.play()

func die():
	emit_signal("got_shot")

func _on_HitBox_body_entered(body: Node) -> void:
	if body.is_in_group("bullet"):
		die()

func play_anim_before_teleport():
	$AnimationPlayer.play("BeforeTeleport")

func play_anim_after_teleport():
	$AnimationPlayer.play("AfterTeleport")

func set_sprite(num):
	$Sprite.frame = num
