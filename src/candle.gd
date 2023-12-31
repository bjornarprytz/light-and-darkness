@tool
extends Sprite2D

@export var _hp : float = 1.0

@onready var inner_flame : PointLight2D = $InnerFlame
@onready var outer_flame : PointLight2D = $OuterFlame

@onready var inner_base_scale = inner_flame.scale
@onready var outer_base_scale = outer_flame.scale

@onready var label = $Label

var _time : float
var _held : bool
var _offset : Vector2

func _physics_process(delta: float) -> void:
	_time += (delta * randf_range(1.0, 16.0))
	var c = (cos(_time) -1.0)
	inner_flame.scale = inner_base_scale + (Vector2(c, c) * .07)
	outer_flame.scale = outer_base_scale + (Vector2(c, c) * .1)
	
func _process(delta: float) -> void:
	if (_held):
		global_position = get_global_mouse_position() - _offset


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton):
		_held = event.is_pressed()
		_offset = get_global_mouse_position() - global_position
		if _held and label != null:
			label.queue_free()
			
func shrink():
	_hp = _hp - 0.1
	if (_hp < 0.0):
		_hp = 0.0
	var tween = create_tween()
	tween.tween_property(self, 'scale', Vector2(_hp, _hp), .5)
	
