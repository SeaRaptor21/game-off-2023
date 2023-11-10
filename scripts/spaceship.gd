extends CharacterBody2D

const mass = 74842.741
@onready var planets = get_node("../Planets")
@onready var bg = get_node("../Background/Layer")

func _physics_process(delta):
	for planet in planets.get_children():
		var distance = (((position.x - planet.position.x)**2 + (position.y - planet.position.y)**2)*Game.scale)
		var force = (mass*planet.mass)/distance
		var acc = force / mass
		velocity += -acc*((position-planet.position).normalized())*delta*1e-12
	rotation = velocity.angle()
	#bg.motion_offset += velocity*delta*0.01
	move_and_slide()
