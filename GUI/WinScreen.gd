extends CanvasLayer


func _ready():
	$AnimationPlayer.play("fade_in")
	if OS.has_feature("web"):
		$MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/QuitButton.hide()


func _on_RestartButton_pressed():
	$AnimationPlayer.play("fade_out")


func _on_QuitButton_pressed() -> void:
	self.queue_free()
	get_tree().quit()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_out":
		# OK, this isn't ideal but preloading this  at the top generates a
		# circular reference which is obviously not nice either.
		var stage_scene = load("res://Stage.tscn")
		get_tree().change_scene_to(stage_scene)
		self.queue_free()
