extends CanvasLayer

func _on_RestartButton_pressed():
	self.queue_free()
	


func _on_QuitButton_pressed() -> void:
	self.queue_free()
	#quit()
