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

func hit(): # ADD SCREEN SHAKE
	get_parent().get_parent().get_node("Camera2D").shake(0.2, 10, 4)
	$Hit.play()
	$BulletHitBullet.play()
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	$Particles2D.emitting = false
	yield(get_tree().create_timer(2), "timeout")
	queue_free()

