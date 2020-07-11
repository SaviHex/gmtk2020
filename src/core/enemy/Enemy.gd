extends Area2D

signal shot
signal got_shot

export var path_color: Color = Color.white
export var speed: float = 1.0
export var shoot_time: float = 5.0
export var bullet_speed: float = 80

onready var pivot = $Pivot
onready var bullet_point = $Pivot/BulletPoint
onready var shoot_timer: Timer = $ShootTimer

var bullet = preload("res://core/bullet/Bullet.tscn")

var initialized: bool = false
var current_path
var current_target: Node2D

func _ready():
	self.shoot_timer.wait_time = self.shoot_time
	self.shoot_timer.start()

func init(path: Path2D, target: Node2D):
	self.current_path = path
	self.current_path.color = self.path_color
	self.current_path.start(self.speed)
	self.current_target = target
	self.initialized = true

func disable():
	self.current_path.stop()
	self.initialized = false

func _process(delta: float) -> void:
	if self.initialized:
		self.position = self.current_path.get_current_point()
		self.pivot.look_at(self.current_target.position)

func shoot():
	var b = bullet.instance()
	b.start(bullet_point.global_position, pivot.rotation, bullet_speed)
	get_parent().add_child(b)
	emit_signal("shot")

func _on_ShootTimer_timeout() -> void:
	shoot()

func die():
	emit_signal("got_shot")

func _on_Enemy_body_entered(body: Node) -> void:
	if body.is_in_group("bullet"):
		die()
