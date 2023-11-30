extends Node2D


const button_scene = preload("res://level_button.tscn")


func _ready():
	for num in range(len(Game.paths)):
		var instance = button_scene.instantiate()
		instance.number = num
		instance.get_node("Label").text = str(num+1)
		instance.position = Vector2(75.0+num*120, 160.0)
		add_child(instance)


func _process(delta):
	$ParallaxBackground.scroll_offset += Vector2(100*delta, 50*delta)
