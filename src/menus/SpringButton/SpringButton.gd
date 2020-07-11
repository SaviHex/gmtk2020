extends Tween

export var grow_factor: float = 0.2
export var tween_speed: float = 0.5
export (Color) var pressed_color: Color

var parent_button: BaseButton
var normal_size: Vector2
var small_size: Vector2
var big_size: Vector2

func _ready() -> void:
	self.parent_button = get_parent()
	connect_signals(self.parent_button)


func connect_signals(parent: BaseButton):
	parent.connect("ready", self, "_on_Control_ready")
	parent.connect("mouse_entered", self, "_on_Button_mouse_entered")
	parent.connect("mouse_exited", self, "_on_Button_mouse_exited")
	parent.connect("button_up", self, "_on_Button_button_up")
	parent.connect("button_down", self, "_on_Button_button_down")

func _on_Control_ready() -> void:
	self.normal_size = self.parent_button.rect_scale
	self.big_size = self.normal_size * (1 + self.grow_factor)
	self.small_size = self.normal_size * (1 - self.grow_factor)

	self.parent_button.rect_pivot_offset = self.parent_button.rect_size * 0.5


func _on_Button_mouse_entered() -> void:
#	print("_on_Button_mouse_entered")
	self.interpolate_property(self.parent_button, "rect_scale", self.parent_button.rect_scale, big_size, tween_speed, Tween.TRANS_ELASTIC, EASE_OUT)
	self.start()

func _on_Button_mouse_exited() -> void:
#	print("_on_Button_mouse_exited")
	self.interpolate_property(self.parent_button, "rect_scale", self.parent_button.rect_scale, normal_size, tween_speed, Tween.TRANS_ELASTIC, EASE_OUT)
	self.start()


func _on_Button_button_down() -> void:
#	print("_on_Button_button_down")
	self.interpolate_property(self.parent_button, "modulate", self.parent_button.modulate, pressed_color, tween_speed, Tween.TRANS_EXPO, EASE_OUT)
	self.interpolate_property(self.parent_button, "rect_scale", self.parent_button.rect_scale, small_size, tween_speed, Tween.TRANS_ELASTIC, EASE_OUT)
	self.start()


func _on_Button_button_up() -> void:
#	print("_on_Button_button_up")
	self.interpolate_property(self.parent_button, "modulate", self.parent_button.modulate, Color.white, tween_speed, Tween.TRANS_EXPO, EASE_OUT)
	self.interpolate_property(self.parent_button, "rect_scale", small_size, normal_size, tween_speed, Tween.TRANS_ELASTIC, EASE_OUT)
	self.start()
