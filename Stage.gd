extends Node2D


var mystery_boxes = []
var symbols = []
var nkis = []

const MIN_DISTANCE = 128*1.5
const MIN_DISTANCE_FROM_CENTER = 128*1.5
const WIGGLE_RANGE = 32

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
	print(dir.get_current_dir())
	if dir.open("res://assets/symbols") == OK:
		print(dir.get_current_dir())
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

#func load_symbols_textures():
#	var l = list_symbols()
#	for n in l:
#		var fn = "res://assets/symbols/" + n
#		symbols.append(load(fn))
#	symbols.shuffle()

func load_nkis():
	var f = File.new()
	f.open("res://assets/nkis.txt", File.READ)
	while !f.eof_reached():
		nkis.append(f.get_line())
	f.close()
	nkis.shuffle()

func _ready():
	$HUD/Fader.show()
	$HUD/PanelContainer.modulate = Color(1,1,1,0)
	randomize()
	var Global = get_node("/root/Global")
	# load_symbols_textures()
	symbols = Global.symbols
	
	# So, loading PNGs on the fly is not ok, but a random txt file gets bundled
	# no questions asked? Ok, then...
	load_nkis()
	
	var box_scene = preload("res://Actors/MysteryBox.tscn")
	var center = Vector2(512, 300)

	# MAKE KITTEN!
	var kitten = box_scene.instance()
	kitten.set_script(load("res://Actors/Kitten.gd"))
	kitten.get_node("BaseSprite").modulate = Color(Global.colors[randi() % Global.colors.size()])
	kitten.get_node("SymbolSprite").texture = symbols.pop_front()
	kitten.connect("is_kitten", self, "_on_Actor_is_kitten")
	mystery_boxes.append(kitten)
	var kitten_position = pick_box_position() + center
	while !check_distance(kitten_position, MIN_DISTANCE) || (kitten_position.distance_to(center) < MIN_DISTANCE_FROM_CENTER):
		kitten_position += Vector2(rand_range(-1, 1), rand_range(-1, 1)) * rand_range(WIGGLE_RANGE/2, WIGGLE_RANGE)
	kitten.position = kitten_position + center
	$Boxes.call_deferred("add_child", kitten)

	# MAKE MYSTERY BOXES!
	var mystery_boxes_amt = 32
	for i in range(mystery_boxes_amt):
		var position = pick_box_position() + center
		while !check_distance(position, MIN_DISTANCE) || (position.distance_to(center) < MIN_DISTANCE_FROM_CENTER):
			position += Vector2(rand_range(-1, 1), rand_range(-1, 1)) * rand_range(WIGGLE_RANGE/2, WIGGLE_RANGE)
		var box = box_scene.instance()
		box.get_node("BaseSprite").modulate = Color(Global.colors[i % Global.colors.size()])
		box.get_node("SymbolSprite").texture = symbols[i % symbols.size()]
		box.what = nkis[i % nkis.size()]
		box.connect("is_kitten", self, "_on_Actor_is_kitten")
		mystery_boxes.append(box)
		box.position = position
		$Boxes.call_deferred("add_child", box)
	
	# Gotta do that bounding box dance here...
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF
	for box in mystery_boxes:
		if min_x > box.position.x:
			min_x = box.position.x
		if min_y > box.position.y:
			min_y = box.position.y
		if max_x < box.position.x:
			max_x = box.position.x
		if max_y < box.position.y:
			max_y = box.position.y
	# ... and set the autotiles accordingly.
	for x in range(int(min_x/64)-3, int(max_x/64)+3):
		for y in range(int(min_y/64)-3, int(max_y/64)+3):
			$TileMap.set_cell(x, y, 0)
	# Don't forget to give them a shake otherwise they won't bind correctly.
	$TileMap.update_bitmask_region()
	$HUD/Fader.fade_in()

func _on_Robot_approach_box() -> void:
	if OS.is_debug_build():
		print("* Robot sees a box")

func _on_Robot_leave_box() -> void:
	if OS.is_debug_build():
		print("* Robot leaves the box")

	$HUD.hide_panel()

func _on_Actor_is_kitten(is_kitten, what_is) -> void:
	if OS.is_debug_build():
		print("<box> ", what_is)

	if is_kitten:
		$HUD/Fader.fade_out()
	else:
		$HUD.show_panel(what_is)


func _on_Fader_fade_finished(anim_name: String) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene("res://GUI/WinScreen.tscn")
