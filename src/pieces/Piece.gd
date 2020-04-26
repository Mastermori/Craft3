extends Area2D

var highlight := false setget set_highlight

var clicked := false

var start_position : Vector2
var speed_weight : float
var touch_position : Vector2

onready var sprite := $Sprite
onready var anim_player := $AnimationPlayer
onready var tween := $Tween

func _ready():
	pass

func _physics_process(delta):
	if clicked:
		if Globals.is_mobile:
			if global_position.distance_to(touch_position) > 1:
				global_position = lerp(global_position, touch_position, speed_weight)
			else:
				global_position = touch_position
		else:
			var mouse_position := get_global_mouse_position()
			if global_position.distance_to(mouse_position) > 1:
				global_position = lerp(global_position, mouse_position, speed_weight)
			else:
				global_position = mouse_position

func _input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			select()
			touch_position = event.position

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click") and highlight:
			select()
			get_tree().set_input_as_handled()
		elif event.is_action_released("click") and clicked:
			deselect()
			get_tree().set_input_as_handled()
	elif event is InputEventScreenTouch:
		if clicked and not event.pressed:
			deselect()
			get_tree().set_input_as_handled()
	elif event is InputEventScreenDrag:
		touch_position = event.position

func select():
	start_position = position
	speed_weight = .2
	anim_player.play("select")
	clicked = true

func deselect():
	anim_player.play("deselect")
	if highlight:
		anim_player.play("highlight")
	clicked = false
	tween.interpolate_property(self, "position", position, start_position, .3, Tween.TRANS_CUBIC)
	tween.start()

func _on_AnimationPlayer_animation_changed(old_name, new_name):
	if old_name == "select":
		speed_weight = .5
		
func _on_Piece_mouse_entered():
	set_highlight(true)

func _on_Piece_mouse_exited():
	set_highlight(false)

func set_highlight(value : bool):
	if not clicked:
		if value and not highlight:
			anim_player.play("highlight")
		elif not value and highlight:
			anim_player.play_backwards("highlight")
	highlight = value
