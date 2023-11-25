extends Node2D


var density = 5515.0
var radius = 6.371e6
var mass = density * 4/3*PI*radius**3


func _ready():
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()
	$Area2D/CollisionShape2D.shape.radius = radius/Game.scale
	var image_scale = radius/Game.scale/(319/2)
	$Texture.scale.x = image_scale
	$Texture.scale.y = image_scale


func scale_to(r):
	radius = r
	mass = density * 4/3*PI*radius**3
	$Area2D/CollisionShape2D.shape.radius = radius/Game.scale
	var image_scale = radius/Game.scale/(319/2)
	$Texture.scale.x = image_scale
	$Texture.scale.y = image_scale

func _on_area_2d_body_entered(body):
	if body.name == 'Ship' and Game.launched:
		Game.win()
