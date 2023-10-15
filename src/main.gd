extends Node2D

@onready var art : Sprite2D = $Art
@onready var candle : Node2D = $Candle
@onready var prompt : LineEdit = $CanvasLayer/LineEdit

var solution : String
var leeway : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_art()
	scale_art()
	
	prompt.text_submitted.connect(check_answer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	art.global_position = - map_point_to_rect(candle.global_position, get_viewport_rect().size, leeway)
	

func check_answer(answer : String):
	var result = solution == answer.replace(" ", "")
	
	if (result):
		var tween = create_tween()
		tween.tween_property($CanvasModulate, 'color', Color.WHITE, 2.0)
	else:
		print("NAY")

func map_point_to_rect(point, screen_size, target_rect):
	# Calculate the mapping for the X-coordinate
	var x_ratio = target_rect.x / screen_size.x
	var x_mapped = (point.x * x_ratio)

	# Calculate the mapping for the Y-coordinate
	var y_ratio = target_rect.y / screen_size.y
	var y_mapped = (point.y * y_ratio)

	return Vector2(x_mapped, y_mapped)

func load_art():
	var arts = []
	
	var dir = DirAccess.open("res://img")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".jpg"):
				arts.push_back(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	var fn = arts.pick_random()
	solution = fn.split(".")[0]
	
	art.texture = load("res://img/" + fn)

func scale_art():
	var artSize = art.texture.get_size()
	var screenSize = get_viewport_rect().size
	
	var scaleX = screenSize.x / artSize.x 
	var scaleY = screenSize.y / artSize.y

	var s = max(scaleX, scaleY)
	
	art.scale = Vector2(s, s)

	leeway = (art.texture.get_size() * s) - screenSize
	
	print(leeway)


var _promptTween : Tween

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (_promptTween):
		_promptTween.kill()
		
	_promptTween = create_tween()
	_promptTween.tween_property(prompt, 'modulate:a', 0.0, 0.3)
	_promptTween.tween_callback(_hide_promt)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if (_promptTween):
		_promptTween.kill()
	prompt.visible = true
	_promptTween = create_tween()
	_promptTween.tween_property(prompt, 'modulate:a', 1.0, 0.5)

func _hide_promt():
	prompt.visible = false
