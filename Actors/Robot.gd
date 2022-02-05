extends Actor

signal see_box
signal leave_box

export var speed: = Vector2(10000, 10000)
var angle: = 0.0
var angular_speed: = 1.5
var active_actor: Actor = null

onready var leave_timer = $LeaveTimer

func _ready():
	leave_timer.set_wait_time(1)
	pass

func _physics_process(delta: float) -> void:
	angle += Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var direction: = get_direction().rotated(angle * delta * angular_speed)
	if (direction.length() > 0):
		get_node("RobotSprite").playing = true
	else:
		get_node("RobotSprite").playing = false
	self.get_node("RobotSprite").set_rotation(angle * delta * angular_speed)
	velocity = speed * delta * direction
	velocity = move_and_slide(velocity)

func get_direction() -> Vector2:
	return Vector2(
		0.0,
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

func is_kitten():
	emit_signal("is_kitten", false, "No, silly, I'm yourself!")

func _process(_delta):
	if Input.is_action_just_released("ask_kitten") and active_actor != null:
		if OS.is_debug_build():
			print("<robot> Hey, ", active_actor, "... are you kitten?")
		active_actor.is_kitten()

func _on_BoxDetector_body_entered(body: Actor) -> void:
	if body == self:
		return
		
	if OS.is_debug_build():
		print("<robot> I see a mystery box...")

	leave_timer.stop()
	active_actor = body
	body.is_kitten()
	emit_signal("see_box")

func _on_BoxDetector_body_exited(body: Actor) -> void:
	if body == self:
		return
	leave_timer.start(1.0)

func _on_LeaveTimer_timeout():
	active_actor = null
	emit_signal("leave_box")
	if OS.is_debug_build():
		print("<robot> KHTXBAI")
