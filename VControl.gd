extends Control

func _input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventScreenTouch:
		if _is_point_inside_joystick(event.position):
			print(event)
		

func _is_point_inside_joystick(point: Vector2) -> bool:
	var x: bool = point.x >= rect_global_position.x and point.x <= rect_global_position.x + rect_size.x
	var y: bool = point.y >= rect_global_position.y and point.y <= rect_global_position.y + rect_size.y
	return x and y
