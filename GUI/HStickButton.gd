# Liberally inspired by
# https://github.com/Gonkee/Gonkees-Shaders

extends TouchScreenButton

export var center = Vector2(32, 32)
export var boundaries = Vector2(64, 32)
export var return_acc = 20
export var threshold = 8

export var action_left = "ui_left"
export var action_right = "ui_right"

var ongoing_drag = -1

func _ready() -> void:
	position = -boundaries * Vector2(0.5, 1)


func _process(delta):
	position.y = -boundaries.y
	if ongoing_drag == -1:
		var position_diff = 0-center.x - position.x
		position.x += position_diff * return_acc * delta


func get_button_position():
	return Vector2((position + center).x, 0)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var relative_event_pos = event.position - get_parent().global_position
		
		if event.get_index() == ongoing_drag or \
			(-boundaries.x < relative_event_pos.x and relative_event_pos.x < boundaries.x and \
			 -boundaries.y < relative_event_pos.y and relative_event_pos.y < boundaries.y):
			set_global_position(event.position - center * global_scale)
			
			var pos = get_button_position()
			if (boundaries.x - center.x) < pos.x or pos.x < -(boundaries.x - center.x):
				pos.x = max(-boundaries.x + center.x, min(pos.x, boundaries.x - center.x))
			set_position(pos - center)
			
			ongoing_drag = event.get_index()
			
			print(get_value())
			if get_value() > 0:
				Input.action_press(action_left, get_value())
			elif get_value() < 0:
				Input.action_press(action_right, -get_value())
	
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		Input.action_release(action_left)
		Input.action_release(action_right)


func get_value():
	if abs(get_button_position().x) > threshold:
		return -get_button_position().x / center.x
	return 0

