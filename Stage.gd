extends Node2D


var mystery_boxes = []
var symbols = []
onready var nki_file = "res://assets/nkis.txt"
var nkis = []

const colors = [
	"#f44336",
	"#e81e63",
	"#9c27b0", 
	"#673ab7", 
	"#3f51b5",
	"#2196f3", 
	"#03a9f4",
	"#00bcd4",
	"#009688",
	"#4caf50",
	"#8bc34a", 
	"#cddc39", 
	"#ffeb3b", 
	"#ffc107",
	"#ff9800",
	"#ff5722"
]

func check_distance(p: Vector2, min_distance: float):
	for box in mystery_boxes:
		var d = p.distance_to(box.position)
		if d < min_distance:
			return false
	return true

func pick_box_position():
	var radius = rand_range(0, 512)
	var angle = rand_range(0, 2*PI)
	return Vector2(radius * cos(angle), radius * sin(angle))

func list_symbols():
	var dir = Directory.new()
	if dir.open("res://assets/symbols/") == OK:
		dir.list_dir_begin()
		var file_names = []
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.match("char_???.png"):
				file_names.append(file_name)
			file_name = dir.get_next()
		return file_names
	else:
		print("An error occurred while loading the symbols.")
		return []

func load_symbols_textures():
	var l = list_symbols()
	for n in l:
		symbols.append(ResourceLoader.load("res://assets/symbols/" + n))
	symbols.shuffle()

func load_nkis():
	var f = File.new()
	f.open(nki_file, File.READ)
	while !f.eof_reached():
		nkis.append(f.get_line())
	f.close()
	nkis.shuffle()

func _ready():
	$HUD/MarginContainer/Label.visible = false
	randomize()
	load_nkis()
	load_symbols_textures()
	
	var box_scene = preload("res://Actors/MysteryBox.tscn")
	var center = Vector2(512, 300)
	# MAKE KITTEN!
	var kitten = box_scene.instance()
	kitten.set_script(load("res://Actors/Kitten.gd"))
	kitten.get_node("BaseSprite").modulate = Color(1,1,1,1)
	kitten.get_node("SymbolSprite").texture = null
	kitten.connect("is_kitten", self, "_on_Actor_is_kitten")
	mystery_boxes.append(kitten)
	var kitten_position = pick_box_position() + center
	while !check_distance(kitten_position, 256) || (kitten_position.distance_to(center) < 128):
		kitten_position += Vector2(rand_range(-1, 1), rand_range(-1, 1)) * rand_range(0, 32*4)
	kitten.position = kitten_position + center
	$Boxes.call_deferred("add_child", kitten)

	var mystery_boxes_amt = 32
	for i in range(mystery_boxes_amt):
		var position = pick_box_position() + center
		while !check_distance(position, 256) || (position.distance_to(center) < 128):
			position += Vector2(rand_range(-1, 1), rand_range(-1, 1)) * rand_range(0, 32*4)
		var box = box_scene.instance()
		box.get_node("BaseSprite").modulate = Color(colors[i % colors.size()])
		box.get_node("SymbolSprite").texture = symbols[i % symbols.size()]
		box.what = nkis[i % nkis.size()]
		box.connect("is_kitten", self, "_on_Actor_is_kitten")
		mystery_boxes.append(box)
		box.position = position
		$Boxes.call_deferred("add_child", box)	

func _on_Robot_approach_box() -> void:
	# print("* Robot sees a box")
	pass

func _on_Robot_leave_box() -> void:
	# print("* Robot leaves a box")
	$HUD/MarginContainer/Label.text = ""
	$HUD/MarginContainer/Label.visible = false

func _on_Actor_is_kitten(is_kitten, what_is) -> void:
	# print("<box> ", what_is)
	if is_kitten:
		get_tree().change_scene("res://GUI/WinScreen.tscn")
	else:
		$HUD/MarginContainer/Label.text = what_is
		$HUD/MarginContainer/Label.visible = true

func quit() -> void:
	print("QUITTONE")

func restart():
	get_tree().reload_current_scene()
