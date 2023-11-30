extends TextureButton


var number = 0


func _on_mouse_entered():
	$Label.add_theme_color_override("font_color", Color('#eeb846'))


func _on_mouse_exited():
	#if number in Game.completed_levels:
	#	$Label.add_theme_color_override("font_color", Color('#3bac45'))
	#else:
	#	pass
	$Label.add_theme_color_override("font_color", Color('#7cd7d4'))


func _on_pressed():
	#get_tree().change_scene_to_file("res://main.tscn")
	Game.level = Game.paths[number]
	Game.level_number = number
	Game.load_level(Game.paths[number])
	
