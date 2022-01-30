extends MysteryBox
class_name Kitten

func is_kitten():
	$BaseSprite.modulate = Color(1,1,1,1)
	emit_signal("is_kitten", true, "YES, I AM KITTEN!")

