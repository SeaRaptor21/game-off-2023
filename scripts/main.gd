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
		settings_open = false
		$Control/SettingsPopup.visible = false
	else:
		settings_open = true
		$Control/SettingsPopup.visible = true


func _on_replay_pressed():
	Game.load_level(Game.level)
