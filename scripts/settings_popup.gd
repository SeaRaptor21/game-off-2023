extends Node2D

# Math for the popup texture
# the original table_03.png is 751 (wide) by 461 (high)
# To correctly place the popup under the existing two buttons on the main
# screen, the following is realized:
#   - the right of the popup should match the very right of the rightmost
#     button -- which is x = 1026 (or 1025)
#   - the top of the popup should be at 140. This provides the same distance
#     from the bottom of the buttons as the distance between the buttons
#
# Currently the option buttons on this view look right to be scaled at about
# 0.25 of the original 211 x 211 pixels when the frame Sprint2D is scaled 
# at 0.7
#
# The popup "frame" (table_03.png) is scaled to about 0.45 of original size
# This means that the option buttons now must be scaled : 0.25 * (0.7 / 0.45) = 0.389
# this math will assist someone in the future trying to scale the 
# popup to fit more / less items
#
# to correctly place the popup (Sprint2D), the x / y position of the popup
# is expressed as the *center* of the object. Therefore, to get the right at 1025
# and the top at 140, the following math is utilized:
#    x = 1025 - (751 / 2 * 0.45)    :: x = right - (width / 2 * final_scaling)
#    y = 140 + (461 / 2 * 0.45)     :: y = top + (height / 2 * final_scaling)
#
# there might be other ways to scale / position the items, but it appeared this
# wasn't too bad. Once the inside buttons / labels resized, they were placed
# visually

# setting variables for the individual setting items
# set these before instantiating or bringing into the scene, and the buttons
# will correctly set themselves.
# upon close these variables will indicate the user's preferances
# if for some reason, these mechanisms aren't correctly working in the situation
# you need, you can call set_button_textures() manually on this object

var texture_on  = load("res://assets/ui/pack 2/PNG/Buttons/BTNs/Ok_BTN.png")
var texture_off = load("res://assets/ui/pack 2/PNG/Ship_Parts/Table_03.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize buttons based on initial settings
	set_button_textures()
	
# assuming this popup will be added to the node tree when desired -- this
# method will make sure the buttons are correctly assigned before displaying
func _enter_tree():
	set_button_textures()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_button_textures():
	if Game.music_on:
		$"Sprite2D/Music Button".texture_normal = texture_on
	else:
		$"Sprite2D/Music Button".texture_normal = texture_off
				
	if Game.sfx_on:
		$"Sprite2D/SFX Button".texture_normal = texture_on
	else:
		$"Sprite2D/SFX Button".texture_normal = texture_off

func _on_music_button_pressed():
	Game.music_on = not Game.music_on
	set_button_textures()

func _on_sfx_button_pressed():
	Game.sfx_on = not Game.sfx_on
	set_button_textures()

# when Exit button pressed
func _on_exit_button_pressed():
	self.queue_free()
