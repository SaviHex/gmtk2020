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
onready var shoot_progress: TextureProgress = $Pivot/BulletPoint/ShootProgress

var bullet = preload("res://core/bullet/Bullet.tscn")

var initialized: bool = false
var current_path
var current_target: Node2D
var elapsed_time: float setget set_elapsed_time

func _ready():
	self.shoot_progress.max_value = self.shoot_time
	self.elapsed_time = 0


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
	self.elapsed_time = 0
	var b = bullet.instance()
	b.start(bullet_point.global_position, pivot.rotation, bullet_speed)
	get_parent().add_child(b)
	emit_signal("shot")

func _on_ShootTimer_timeout() -> void:
	self.elapsed_time += 0.1
	if self.elapsed_time >= self.shoot_time:
		shoot()

func die():
	emit_signal("got_shot")

func _on_Enemy_body_entered(body: Node) -> void:
	if body.is_in_group("bullet"):
		die()

func set_elapsed_time(value: float):
	elapsed_time = value
	self.shoot_progress.value = value
