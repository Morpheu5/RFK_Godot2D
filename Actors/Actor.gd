extends KinematicBody2D
class_name Actor

signal is_kitten(is_kitten, what)

var velocity := Vector2.ZERO

func is_kitten():
	emit_signal("is_kitten", false, "Sorry, I'm not kitten...")
