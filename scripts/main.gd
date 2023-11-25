extends Node2D


const settings_scene = preload("res://settings_popup.tscn")

var settings_open = false

func _ready():
	$TransitionScreen/AnimationPlayer.play("fade_to_normal")
	
	Game.load_level("res://levels/test_level.json")

func _on_launch_pressed():
	Game.launched = true


func _on_settings_pressed():
	if settings_open:
		$SettingsPopup.queue_free()
		settings_open = false
	else:
		var settings = settings_scene.instantiate()
		$Control.add_sibling(settings)
		settings_open = true


func _on_replay_pressed():
	Game.load_level(Game.level)
