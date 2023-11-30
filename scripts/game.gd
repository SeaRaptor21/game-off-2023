extends Node


const scale = 100000
const planet_scene = preload("res://planet_resizeable.tscn")
const goal_scene = preload("res://goal.tscn")

var launched = false

# Options settings
var music_on = true
var sfx_on = true

var paths = ['res://levels/test_level.json']
var data
var level = paths[0]
var level_number = 0
var completed_levels = []

func parse_json(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	var dict = JSON.parse_string(text)
	file.close()
	return dict

func load_level(path):
	#get_tree().change_scene_to_file("res://main.tscn")
	var main = get_node("/root/Main")
	main.get_node("WinPopup").visible = false
	main.get_node("LosePopup").visible = false
	main.get_node("TransitionScreen/ColorRect").color.a = 0
	data = parse_json(path)
	main.get_node("Ship").position = Vector2(data['start']['x'], data['start']['y'])
	main.get_node("Ship").rotation = 0
	main.get_node("Ship").velocity = Vector2()
	main.get_node("Control/LevelName").text = data['name']
	main.get_node("WinPopup/LevelName").text = data['name']
	main.get_node("LosePopup/LevelName").text = data['name']
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
	var goal = goal_scene.instantiate()
	goal.density = data['goal']['density']
	goal.scale_to(data['goal']['radius'])
	goal.position = Vector2(data['goal']['x'], data['goal']['y'])
	planets.add_child(goal)
		
func win():
	launched = false
	var main = get_node("/root/Main")
	var popup = main.get_node("WinPopup")
	popup.visible = true
	main.get_node("TransitionScreen/ColorRect").color.a = 0.5
	completed_levels.append(level_number)
	
func die():
	launched = false
	var main = get_node("/root/Main")
	var popup = main.get_node("LosePopup")
	popup.visible = true
	main.get_node("TransitionScreen/ColorRect").color.a = 0.5
