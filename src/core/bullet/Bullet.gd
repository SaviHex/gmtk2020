extends KinematicBody2D

var velocity = Vector2()

func start(pos, dir, speed):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		#velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("hit"):
			collision.collider.hit()
		hit()

func hit():
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	$Particles2D.emitting = false
	yield(get_tree().create_timer(2), "timeout")
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	hit()
