extends CanvasLayer

func _on_RestartButton_pressed():
	self.queue_free()
	get_tree().change_scene("res://Stage.tscn")

func _on_QuitButton_pressed() -> void:
	self.queue_free()
	get_tree().quit()
