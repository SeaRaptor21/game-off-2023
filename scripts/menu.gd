extends Node2D

# Animate states
const ANIMATE_NONE = 0
const ANIMATE_START = 1
const ANIMATE_QUIT = 2
const ANIMATE_CREDITS = 3
const main_radius = 166
const low_radius = 120
const high_radius = 200

var rng = RandomNumberGenerator.new()
var animate = ANIMATE_NONE
var radius_inc = 0
var current_radius = main_radius

var bg_texture 

func _ready():
	$"Start Button/CollisionShape2D".shape.radius = main_radius
	$"Quit Button/CollisionShape2D".shape.radius = main_radius
	generate_stars()
	
func _draw():
	draw_texture(bg_texture, Vector2())
	
func _process(delta):
	if animate != ANIMATE_NONE:
		current_radius += radius_inc
		if animate == ANIMATE_START:
			resize_start_button()
		elif animate == ANIMATE_QUIT:
			resize_quit_button()
		elif animate == ANIMATE_CREDITS:
			resize_credits_button()
		if radius_inc > 0:
			if current_radius >= high_radius:
				radius_inc *= -1
		elif radius_inc < 0:
			if current_radius <= low_radius:
				radius_inc *= -1
				
func generate_stars(num_stars = 500):
	var star_pts = []
	var bgImage = Image.create(1150, 650, false, Image.FORMAT_RGB8)
	for n in num_stars:
		var xc = rng.randi_range(2, 1147)
		var yc = rng.randi_range(2,  647)
		star_pts.append(Vector2i(xc,yc))
		var cross = (rng.randi() % 6) == 0
		if cross:
			for ofs in range(-2,3):
				bgImage.set_pixel(xc+ofs, yc, Color.WHITE)
				bgImage.set_pixel(xc, yc+ofs, Color.WHITE)
		else:
			bgImage.set_pixel(xc, yc, Color.WHITE)
	bg_texture = ImageTexture.create_from_image(bgImage)
		

func resize_start_button():
	$"Start Button/CollisionShape2D".shape.radius = current_radius
	var image_scale = float(current_radius) / float(main_radius)
	$"Start Button/Sprite2D".scale.x = image_scale
	$"Start Button/Sprite2D".scale.y = image_scale

func resize_quit_button():
	$"Quit Button/CollisionShape2D".shape.radius = current_radius
	var image_scale = float(current_radius) / float(main_radius)
	$"Quit Button/Sprite2D".scale.x = image_scale
	$"Quit Button/Sprite2D".scale.y = image_scale

func resize_credits_button():
	$"Credits Button/CollisionShape2D".shape.radius = current_radius
	var image_scale = float(current_radius) / float(main_radius)
	$"Credits Button/Sprite2D".scale.x = image_scale
	$"Credits Button/Sprite2D".scale.y = image_scale

func _on_start_button_mouse_entered():
	animate = ANIMATE_START
	radius_inc = 5

func _on_start_button_mouse_exited():
	if animate == ANIMATE_START:
		animate = ANIMATE_NONE
	current_radius = main_radius
	resize_start_button()


func _on_quit_button_mouse_entered():
	animate = ANIMATE_QUIT
	radius_inc = 5


func _on_quit_button_mouse_exited():
	if animate == ANIMATE_QUIT:
		animate = ANIMATE_NONE
	current_radius = main_radius
	resize_quit_button()


func _on_start_button_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton) && event.pressed:
		# print("start clicked")
		get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_button_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton) && event.pressed:
		# print("quit clicked")
		get_tree().quit()
	


func _on_credits_button_mouse_entered():
	animate = ANIMATE_CREDITS
	radius_inc = 5


func _on_credits_button_mouse_exited():
	if animate == ANIMATE_CREDITS:
		animate = ANIMATE_NONE
	current_radius = main_radius
	resize_credits_button()


func _on_credits_button_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton) && event.pressed:
		print("credits clicked")
