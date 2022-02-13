extends CanvasLayer


func _ready():
	$PanelContainer.modulate = Color(1,1,1,0)


func show_panel(text: String):
	$PanelContainer/Label.text = text
	$Tween.interpolate_property($PanelContainer, "modulate", $PanelContainer.modulate, Color(1,1,1,1), 0.25)
	$Tween.start()
	
	pass


func hide_panel():
	$Tween.interpolate_property($PanelContainer, "modulate", $PanelContainer.modulate, Color(1,1,1,0), 0.25)
	$Tween.start()
	pass
