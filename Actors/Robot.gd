extends Actor

signal see_box
signal leave_box

var max_speed: = 150.0
var speed: = 0.0
var angular_speed: = 1.5
var rotation_direction = 0
var active_actor: Actor = null
var are_we_playing = true
var pitch = 1.0

const thumps = [
	preload("res://assets/audio/thump-01.ogg"),
	preload("res://assets/audio/thump-02.ogg"),
	preload("res://assets/audio/thump-03.ogg"),
	preload("res://assets/audio/thump-04.ogg")
]

func _ready():
	$LeaveTimer.set_wait_time(1)


func get_input(delta):
	rotation_direction = 0
	velocity = Vector2.ZERO
	
	var v = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	if v == 0:
		speed -= 100 * delta * sign(speed)
		rotation_direction = (Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left"))
	else:
		speed += 100 * delta * sign(v)
		if (abs(speed) > max_speed):
			speed = sign(speed) * max_speed
		rotation_direction = sign(-v) * (Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left"))
	velocity = transform.y * speed

	$RobotSprite.playing = abs(speed) > 0
	$EngineNoise.pitch_scale = 1.0 + max(0.0, abs(speed/(max_speed*3)))


func _physics_process(delta: float) -> void:
	if !are_we_playing:
		return
	
	get_input(delta)
	rotation += rotation_direction * angular_speed * delta
	velocity = move_and_slide(velocity)


func is_kitten():
	emit_signal("is_kitten", false, "No, silly, I'm yourself!")


func _on_BoxDetector_body_entered(body: Actor) -> void:
	if body == null or body == self:
		return
		
	if OS.is_debug_build():
		print("<robot> I see a mystery box...")

	emit_signal("see_box")
	$LeaveTimer.stop()
	active_actor = body
	body.is_kitten()
	$Thumper.stream = thumps[randi() % thumps.size()]
	$Thumper.play()



func _on_BoxDetector_body_exited(body: Actor) -> void:
	if body == null or body == self:
		return
	$LeaveTimer.start(1.0)


func _on_LeaveTimer_timeout():
	active_actor = null
	emit_signal("leave_box")
	if OS.is_debug_build():
		print("<robot> KHTXBAI")


func fade_engine_noise():
	$EngineFader.interpolate_property($EngineNoise, "volume_db", 0, -80, 2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$EngineFader.start()
