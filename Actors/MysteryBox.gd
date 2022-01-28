extends Actor
class_name MysteryBox

var what = ""

func is_kitten():
	$BaseSprite.modulate = Color(1,1,1,1)
	emit_signal("is_kitten", false, what)
