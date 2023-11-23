extends Node2D


func _ready():
	$TransitionScreen/AnimationPlayer.play("fade_to_normal")
	
	Game.load_level("res://levels/test_level.json")

func _on_launch_pressed():
	Game.launched = true
