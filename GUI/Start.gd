extends CanvasLayer

func _on_Button_pressed() -> void:
	$Fader.show()
	$Fader.fade_out()

func _on_Fader_fade_finished(_anim_name) -> void:
	# OK, this isn't ideal but preloading this  at the top generates a
	# circular reference which is obviously not nice either.
	var stage_scene = load("res://Stage.tscn")
	get_tree().change_scene_to(stage_scene)
	self.queue_free()
