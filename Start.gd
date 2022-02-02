extends CanvasLayer

func _on_Button_pressed() -> void:
	self.queue_free()
	get_tree().change_scene("res://Stage.tscn")
