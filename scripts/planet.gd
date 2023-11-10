extends Node2D

var density = 5515.0
var radius = 6.371e6
var mass = density * 4/3*PI*radius**3

const possible_images = [1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,37,38,40,41]

func _ready():
	$Area2D/CollisionShape2D.shape.radius = radius/Game.scale
	var image_scale = radius/Game.scale/(322/2)
	$Sprite2D.texture = load('res://assets/planets/%d.png' % possible_images.pick_random())
	$Sprite2D.scale.x = image_scale
	$Sprite2D.scale.y = image_scale

func scale_up(factor):
	radius = radius*factor
	mass = density * 4/3*PI*radius**3
	$Area2D/CollisionShape2D.shape.radius = radius/Game.scale
	var image_scale = radius/Game.scale/(322/2)
	$Sprite2D.scale.x = image_scale
	$Sprite2D.scale.y = image_scale
	
func scale_add(num):
	scale_up((radius+num)/radius)

func _on_area_2d_body_entered(body):
	print('You die!!!!')
