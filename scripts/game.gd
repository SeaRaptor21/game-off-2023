extends Node


const scale = 100000
const planet_scene = preload("res://planet_resizeable.tscn")

var launched = false

func parse_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	var dict = JSON.parse_string(text)
	file.close()
	return dict

func load_level(path):
	var main = get_node("/root/Main")
	var data = parse_json(path)
	main.get_node("Control/LevelName").text = data['name']
	var planets = main.get_node("Planets")
	for c in planets.get_children():
		planets.remove_child(c)
	for p in data['planets']:
		var planet = planet_scene.instantiate()
		planet.density = p['density']
		planet.max_radius = p['maxradius']
		planet.min_radius = p['minradius']
		planet.scale_to(p['radius'])
		planet.position = Vector2(p['x'], p['y'])
		planets.add_child(planet)
