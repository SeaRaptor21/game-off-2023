extends Node


const scale = 100000

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
