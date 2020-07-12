extends Path2D

onready var path_follow: PathFollow2D = $PathFollow2D

export var color: Color = Color.white setget set_color

var speed: float = 1.0
var is_stopped: bool = true

func _draw() -> void:
	draw_polyline(curve.get_baked_points(), color, 2.0)

func start(new_speed: float = 1.0):
	self.speed = new_speed
	self.is_stopped = false

func stop():
	self.is_stopped = false

func reset():
	self.path_follow.offset = 0
	self.is_stopped = false

func _process(delta: float) -> void:
	if not self.is_stopped:
		self.path_follow.offset += self.speed
	update()

func get_current_point() -> Vector2:
	return self.path_follow.position

func set_color(value: Color):
	color = value
	update()

func advance(amount):
	self.path_follow.offset += amount
