extends CanvasLayer

var StageScene = preload("res://Stage.tscn")

func _on_Button_pressed() -> void:
	$Fader.show()
	$Fader.fade_out()

func _on_Fader_fade_finished(anim_name) -> void:
	get_tree().change_scene_to(StageScene)
	self.queue_free()
