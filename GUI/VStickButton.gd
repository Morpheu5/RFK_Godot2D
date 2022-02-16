# Liberally inspired by
# https://github.com/Gonkee/Gonkees-Shaders

extends TouchScreenButton

export var center = Vector2(32, 32)
export var boundaries = Vector2(32, 64)
export var return_acc = 20
export var threshold = 8

export var action_up = "ui_up"
export var action_dn = "ui_down"

var ongoing_drag = -1

func _ready() -> void:
	position = -boundaries * Vector2(1, 0.5)


func _process(delta):
	position.x = -boundaries.x
	if ongoing_drag == -1:
		var position_diff = 0-center.y - position.y
		position.y += position_diff * return_acc * delta


func get_button_position():
	return Vector2(0, (position + center).y)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var relative_event_pos = event.position - get_parent().global_position
		
		if event.get_index() == ongoing_drag or \
			(-boundaries.x < relative_event_pos.x and relative_event_pos.x < boundaries.x and \
			 -boundaries.y < relative_event_pos.y and relative_event_pos.y < boundaries.y):
			set_global_position(event.position - center * global_scale)
			
			var pos = get_button_position()
			if (boundaries.y - center.y) < pos.y or pos.y < -(boundaries.y - center.y):
				pos.y = max(-boundaries.y + center.y, min(pos.y, boundaries.y - center.y))
			set_position(pos - center)
			
			ongoing_drag = event.get_index()
			
			print(get_value())
			if get_value() > 0:
				Input.action_press(action_up, get_value())
			elif get_value() < 0:
				Input.action_press(action_dn, -get_value())
	
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoing_drag:
		ongoing_drag = -1
		Input.action_release(action_up)
		Input.action_release(action_dn)


func get_value():
	if abs(get_button_position().y) > threshold:
		return -get_button_position().y / center.y
	return 0

