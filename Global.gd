extends Node2D

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

var symbols: Array

# OK, this is kind of insane but apparently that's what I need to do because
# Godot doesn't export resources that are not "hardcoded" (or, somehow used
# at "compile time".
#
# https://github.com/godotengine/godot/issues/14562
# https://github.com/godotengine/godot-proposals/issues/1632
#
# It sounds odd that this isn't a feature but I guess maybe I don't understand
# how the importing/exporting/packing business works in Godot. Aaanyway, the
# solution seems to be preloading like this to ensure the files are bundled
# within the exported artifact. And no, you can't even read a list of files from
# somewhere because preload() wants a constant string, not a variable.

func _ready():
	symbols = [
		preload("res://assets/symbols/char_033.png"),
		preload("res://assets/symbols/char_034.png"),
		# preload("res://assets/symbols/char_035.png"),  # This is supposed to be Robot
		preload("res://assets/symbols/char_036.png"),
		preload("res://assets/symbols/char_037.png"),
		preload("res://assets/symbols/char_038.png"),
		preload("res://assets/symbols/char_039.png"),
		preload("res://assets/symbols/char_040.png"),
		preload("res://assets/symbols/char_041.png"),
		preload("res://assets/symbols/char_042.png"),
		preload("res://assets/symbols/char_043.png"),
		preload("res://assets/symbols/char_044.png"),
		preload("res://assets/symbols/char_045.png"),
		preload("res://assets/symbols/char_046.png"),
		preload("res://assets/symbols/char_047.png"),
		preload("res://assets/symbols/char_048.png"),
		preload("res://assets/symbols/char_049.png"),
		preload("res://assets/symbols/char_050.png"),
		preload("res://assets/symbols/char_051.png"),
		preload("res://assets/symbols/char_052.png"),
		preload("res://assets/symbols/char_053.png"),
		preload("res://assets/symbols/char_054.png"),
		preload("res://assets/symbols/char_055.png"),
		preload("res://assets/symbols/char_056.png"),
		preload("res://assets/symbols/char_057.png"),
		preload("res://assets/symbols/char_058.png"),
		preload("res://assets/symbols/char_059.png"),
		preload("res://assets/symbols/char_060.png"),
		preload("res://assets/symbols/char_061.png"),
		preload("res://assets/symbols/char_062.png"),
		preload("res://assets/symbols/char_063.png"),
		preload("res://assets/symbols/char_064.png"),
		preload("res://assets/symbols/char_065.png"),
		preload("res://assets/symbols/char_066.png"),
		preload("res://assets/symbols/char_067.png"),
		preload("res://assets/symbols/char_068.png"),
		preload("res://assets/symbols/char_069.png"),
		preload("res://assets/symbols/char_070.png"),
		preload("res://assets/symbols/char_071.png"),
		preload("res://assets/symbols/char_072.png"),
		preload("res://assets/symbols/char_073.png"),
		preload("res://assets/symbols/char_074.png"),
		preload("res://assets/symbols/char_075.png"),
		preload("res://assets/symbols/char_076.png"),
		preload("res://assets/symbols/char_077.png"),
		preload("res://assets/symbols/char_078.png"),
		preload("res://assets/symbols/char_079.png"),
		preload("res://assets/symbols/char_080.png"),
		preload("res://assets/symbols/char_081.png"),
		preload("res://assets/symbols/char_082.png"),
		preload("res://assets/symbols/char_083.png"),
		preload("res://assets/symbols/char_084.png"),
		preload("res://assets/symbols/char_085.png"),
		preload("res://assets/symbols/char_086.png"),
		preload("res://assets/symbols/char_087.png"),
		preload("res://assets/symbols/char_088.png"),
		preload("res://assets/symbols/char_089.png"),
		preload("res://assets/symbols/char_090.png"),
		preload("res://assets/symbols/char_091.png"),
		# preload("res://assets/symbols/char_092.png"),  # [space]
		preload("res://assets/symbols/char_093.png"),
		preload("res://assets/symbols/char_094.png"),
		# preload("res://assets/symbols/char_095.png"),  # _
		preload("res://assets/symbols/char_096.png"),
		preload("res://assets/symbols/char_097.png"),
		preload("res://assets/symbols/char_098.png"),
		preload("res://assets/symbols/char_099.png"),
		preload("res://assets/symbols/char_100.png"),
		preload("res://assets/symbols/char_101.png"),
		preload("res://assets/symbols/char_102.png"),
		preload("res://assets/symbols/char_103.png"),
		preload("res://assets/symbols/char_104.png"),
		preload("res://assets/symbols/char_105.png"),
		preload("res://assets/symbols/char_106.png"),
		preload("res://assets/symbols/char_107.png"),
		preload("res://assets/symbols/char_108.png"),
		preload("res://assets/symbols/char_109.png"),
		preload("res://assets/symbols/char_110.png"),
		preload("res://assets/symbols/char_111.png"),
		preload("res://assets/symbols/char_112.png"),
		preload("res://assets/symbols/char_113.png"),
		preload("res://assets/symbols/char_114.png"),
		preload("res://assets/symbols/char_115.png"),
		preload("res://assets/symbols/char_116.png"),
		preload("res://assets/symbols/char_117.png"),
		preload("res://assets/symbols/char_118.png"),
		preload("res://assets/symbols/char_119.png"),
		preload("res://assets/symbols/char_120.png"),
		preload("res://assets/symbols/char_121.png"),
		preload("res://assets/symbols/char_122.png"),
		preload("res://assets/symbols/char_123.png"),
		preload("res://assets/symbols/char_124.png"),
		preload("res://assets/symbols/char_125.png"),
		preload("res://assets/symbols/char_126.png")
	]
