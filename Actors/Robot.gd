extends Actor

signal see_box
signal leave_box

var speed: = 150
var angular_speed: = 1.5
var rotation_direction = 0

var active_actor: Actor = null

var are_we_playing = true


func _ready():
	$LeaveTimer.set_wait_time(1)


func get_input():
	rotation_direction = 0
	velocity = Vector2.ZERO
	
	var v = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	velocity = transform.y * speed * v
	if v == 0:
		rotation_direction = (Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left"))
	else:
		rotation_direction = sign(-v) * (Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left"))

	$RobotSprite.playing = abs(v) > 0


func _physics_process(delta: float) -> void:
	if !are_we_playing:
		return
	
	get_input()
	rotation += rotation_direction * angular_speed * delta
	velocity = move_and_slide(velocity)


func is_kitten():
	emit_signal("is_kitten", false, "No, silly, I'm yourself!")


func _process(_delta):
	if Input.is_action_just_released("ask_kitten") and active_actor != null:
		if OS.is_debug_build():
			print("<robot> Hey, ", active_actor, "... are you kitten?")
		active_actor.is_kitten()


func _on_BoxDetector_body_entered(body: Actor) -> void:
	if body == null or body == self:
		return
		
	if OS.is_debug_build():
		print("<robot> I see a mystery box...")

	emit_signal("see_box")
	$LeaveTimer.stop()
	active_actor = body
	body.is_kitten()


func _on_BoxDetector_body_exited(body: Actor) -> void:
	if body == null or body == self:
		return
	$LeaveTimer.start(1.0)


func _on_LeaveTimer_timeout():
	active_actor = null
	emit_signal("leave_box")
	if OS.is_debug_build():
		print("<robot> KHTXBAI")
