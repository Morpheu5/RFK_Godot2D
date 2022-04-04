extends Actor
class_name MysteryBox

var what = ""

func is_kitten():
	# Uncomment this one if you want to mark boxes you've already opened
	$BaseSprite.modulate = Color(1,1,1,1)
	emit_signal("is_kitten", false, what)
