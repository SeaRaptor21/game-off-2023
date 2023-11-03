extends StaticBody2D

var density = 5515.0
var radius = 6.371e6
var mass = density * 4/3*PI*radius**3

func _ready():
	$CollisionShape2D.shape.radius = radius/Game.scale
	var image_scale = radius/Game.scale/156
	$Sprite2D.scale.x = image_scale
	$Sprite2D.scale.y = image_scale
