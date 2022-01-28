extends KinematicBody2D
class_name Actor

signal is_kitten(is_kitten, what_is)

var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
	pass

func is_kitten():
	emit_signal("is_kitten", false, "Sorry, I'm not kitten...")
