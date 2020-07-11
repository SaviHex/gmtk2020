extends KinematicBody2D

export var speed: float = 1.0
export var min_shoot_time: float = 1.0
export var max_shoot_time: float = 5.0

onready var pivot = $Pivot
onready var bullet_point = $Pivot/BulletPoint
onready var shoot_timer: Timer = $ShootTimer

var bullet = preload("res://core/bullet/Bullet.tscn")

var initialized: bool = false
var current_path
var current_target: Node2D

func _ready():
	randomize()
	var random_time = rand_range(self.min_shoot_time, self.max_shoot_time)
	self.shoot_timer.wait_time = random_time
	self.shoot_timer.start()

func init(path: Path2D, target: Node2D):
	self.current_path = path
	self.current_path.start(self.speed)
	self.current_target = target
	self.initialized = true

func _process(delta: float) -> void:
	if self.initialized:
		self.position = self.current_path.get_current_point()
		self.pivot.look_at(self.current_target.position)

func shoot():
	var b = bullet.instance()
	b.start(bullet_point.global_position, pivot.rotation)
	get_parent().add_child(b)


func _on_ShootTimer_timeout() -> void:
	shoot()
