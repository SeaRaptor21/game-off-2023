extends Node2D

# Animate states
const ANIMATE_NONE = 0
const ANIMATE_START = 1
const ANIMATE_QUIT = 2
const ANIMATE_CREDITS = 3
const main_radius = 166
const low_radius = 166
const high_radius = 200
const animation_speed = 0.5

const IMAGE_SCALE = 1.5
# Images derived from drawing provided by Eric
const IMAGE_G = [
		Vector2(100.0, -100.0) * IMAGE_SCALE,
		Vector2(20.0,  -100.0) * IMAGE_SCALE,
		Vector2(0.0,   -45.0) * IMAGE_SCALE,
		Vector2(45.0,  0.0) * IMAGE_SCALE,
		Vector2(100.0,  0.0) * IMAGE_SCALE,
		Vector2(100.0, -45.0) * IMAGE_SCALE,
		Vector2(40.0,  -45.0) * IMAGE_SCALE
	]
	
const IMAGE_W = [
		Vector2(320.0, -100.0) * IMAGE_SCALE,
		Vector2(350.0, 0.0) * IMAGE_SCALE,
		Vector2(370.0, -45.0) * IMAGE_SCALE,
		Vector2(390.0, 0.0) * IMAGE_SCALE,
		Vector2(420.0, -100.0) * IMAGE_SCALE
	]

var rng = RandomNumberGenerator.new()
var animate = ANIMATE_NONE
var radius_inc = 0
var current_radius = main_radius
var constellations = []

var bg_texture 

func _ready():
	$"Start Button/CollisionShape2D".shape.radius = main_radius
	$"Quit Button/CollisionShape2D".shape.radius = main_radius
	generate_stars()
	$TransitionScreen/ColorRect.color = Color(0,0,0,0)
	
func _draw():
	draw_texture(bg_texture, Vector2())
	draw_constellation_lines()
	
func _process(_delta):
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
				
func compute_stars(num_stars):
	var star_pts = []
	for n in num_stars:
		var xc = rng.randi_range(2, 1147)
		var yc = rng.randi_range(2,  647)
		star_pts.append(Vector2(xc,yc))
	return star_pts
	
## from here to function find_image: Jay's best attempt at porting
## Eric's star image find algorithm written in Python over to
## GDScript. GDScript does not have some of the nicer "functional" 
## features of Python, so manual algorithms were employed.
## All in All performance not too bad
func closest_star(stars, coord):
	var mstar_index = 0
	var mdist       = 10000.0   # impossibly large
	for star_idx in range(0,stars.size()):
		var star = stars[star_idx]
		var dist = star.distance_to(coord)
		if dist < mdist:
			mdist = dist
			mstar_index = star_idx
	return [mstar_index, mdist]
	
func get_best_possibility(possibilities):
	var best_error  = possibilities[0][1]
	var best_points = possibilities[0][0]
	for poss in possibilities:
		if poss[1] < best_error:
			best_error = poss[1]
			best_points = poss[0]
	return best_points

func find_image(image,stars):
	var possibilities = []
	for star in stars:
		var points = []
		var error = 0
		for i in image:
			var zz = closest_star(stars, i+star)
			var closest_index = zz[0]
			var err = zz[1]
			var closest = stars[closest_index]
			points.append(closest)
			error += err
		possibilities.append([points, error])
	return get_best_possibility(possibilities)
				
func generate_stars(num_stars = 500):
	var star_pts = compute_stars(num_stars)
	var bgImage = Image.create(1150, 650, false, Image.FORMAT_RGB8)
	for star in star_pts:
		bgImage.set_pixel(star.x,star.y, Color.WHITE)
		
		#var cross = (rng.randi() % 6) == 0
		#if cross:
		#	draw_big_star_at(bgImage, star)
		
	var pts = find_image(IMAGE_G, star_pts)
	draw_big_stars(bgImage, pts)
	constellations.append(pts)
	pts = find_image(IMAGE_W, star_pts)
	draw_big_stars(bgImage, pts)
	constellations.append(pts)
	
	bg_texture = ImageTexture.create_from_image(bgImage)

func draw_big_stars(bgImage, stars):
	for star in stars:
		draw_big_star_at(bgImage, star)
	
func draw_big_star_at0(bgImage, coord):
	for ofs in range(-3,4):
		bgImage.set_pixel(coord.x+ofs, coord.y, Color.WHITE)
		bgImage.set_pixel(coord.x, coord.y+ofs, Color.WHITE)
		
func draw_big_star_at(bgImage, coord):
	for yofs in range(-4, 5):
		var xd = 4 - abs(yofs)
		for xofs in range(-xd, xd+1):
			bgImage.set_pixel(coord.x+xofs, coord.y + yofs, Color(0.4, 0.4, 1.0) )
			
func draw_constellation_lines():
	for con in constellations:
		for pidx in range(0,con.size() - 1):
			draw_line(con[pidx],con[pidx+1],Color(0.4, 0.4, 1.0))

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
	radius_inc = animation_speed

func _on_start_button_mouse_exited():
	if animate == ANIMATE_START:
		animate = ANIMATE_NONE
	current_radius = main_radius
	resize_start_button()


func _on_quit_button_mouse_entered():
	animate = ANIMATE_QUIT
	radius_inc = animation_speed


func _on_quit_button_mouse_exited():
	if animate == ANIMATE_QUIT:
		animate = ANIMATE_NONE
	current_radius = main_radius
	resize_quit_button()


func _on_start_button_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton) && event.pressed:
		# print("start clicked")
		$TransitionScreen/AnimationPlayer.play("fade_to_black")


func _on_quit_button_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton) && event.pressed:
		# print("quit clicked")
		get_tree().quit()
	


func _on_credits_button_mouse_entered():
	animate = ANIMATE_CREDITS
	radius_inc = animation_speed


func _on_credits_button_mouse_exited():
	if animate == ANIMATE_CREDITS:
		animate = ANIMATE_NONE
	current_radius = main_radius
	resize_credits_button()


func _on_credits_button_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton) && event.pressed:
		get_tree().change_scene_to_file("res://credits.tscn")


func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://main.tscn")
