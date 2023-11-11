extends Node2D

var density = 5515.0
var radius = 6.371e6
var mass = density * 4/3*PI*radius**3

var mouse_in_area2d = false
var mouse_in_area2d2 = false
var dragging = false

const max_radius = 6.371*10**6.5
const min_radius = 6.371e6

const possible_images = [1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,37,38,40,41]

func _ready():
	$Area2D/Collision.shape.radius = radius/Game.scale
	$Area2D2/Collision.shape.radius = radius/Game.scale-20
	var image_scale = radius/Game.scale/(322/2)
	$Texture.texture = load('res://assets/planets/%d.png' % possible_images.pick_random())
	$Texture.scale.x = image_scale
	$Texture.scale.y = image_scale
	$SizeHandle.position.x = radius/Game.scale
	
func _process(delta):
	if dragging:
		scale_to(max(min((get_global_mouse_position()-position).length()*Game.scale, max_radius), min_radius))
		Input.set_default_cursor_shape(Input.CURSOR_HSIZE)

func scale_to(r):
	radius = r
	mass = density * 4/3*PI*radius**3
	$Area2D/Collision.shape.radius = radius/Game.scale
	$Area2D2/Collision.shape.radius = radius/Game.scale-20
	var image_scale = radius/Game.scale/(322/2)
	$Texture.scale.x = image_scale
	$Texture.scale.y = image_scale
	$SizeHandle.position.x = radius/Game.scale
	
func scale_add(num):
	scale_to(radius+num)

func _on_area_2d_body_entered(body):
	if body.name == 'Ship':
		print('You die!!!!')


func _on_area_2d_mouse_entered():
	mouse_in_area2d = true
	if not mouse_in_area2d2:
		Input.set_default_cursor_shape(Input.CURSOR_HSIZE)


func _on_area_2d_mouse_exited():
	mouse_in_area2d = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_area_2d_2_mouse_entered():
	mouse_in_area2d2 = true
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_area_2d_2_mouse_exited():
	mouse_in_area2d2 = false
	Input.set_default_cursor_shape(Input.CURSOR_HSIZE)

func _unhandled_input(event):
	if event.is_action_pressed('click') and mouse_in_area2d and not mouse_in_area2d2:
		dragging = true
	elif event.is_action_released('click'):
		dragging = false
		if not mouse_in_area2d:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
