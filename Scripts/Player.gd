extends KinematicBody2D


const GRAVITY = 10
export (int) var JUMP_SPEED = -350
const JUMP_MAX_AIRBORNE_TIME = 0.2
const FLOOR = Vector2(0, -1)

enum State {RUNNING, SLIDING, JUMPING, FALLING}
enum Swipe {LEFT, RIGHT, UP, DOWN, BLANK}


var on_air_time = 100
var swipeup = false
var swipedown = false
var swiperight = false
var jumping = false
var sliding = false
var falling = false
var dashing = false
var running = true
var onground = true
var prev_jump_pressed = false
var slide_start = 0
var slide_end = 0
var dash_start = 0
var dash_end = 0
var dead = false
var canDash = true
export (int) var slide_distance = 120
export (int) var dash_distance = 120
export (int) var player_velocity = 150
export (int) var dash_velocity = 450
var temp_state 
var temp_y_velocity = 0
var velocity = Vector2()
var elapsed_time = 0    
var start
var speed
var swipe_angle
var start_time
var direction = Vector2()
export (float) var swipe_angle_const = 0.75
var swipe_finished = false
export (int) var swipe_distance = 50

func _ready():
	$slideCollision.disabled = true
	$dashCollision.disabled = true
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			start = event.position
			start_time = elapsed_time
		else:
			direction = event.position - start
			#speed = (direction.length())/(elapsed_time - start_time)
			#direction = direction.normalized()
			swipe_angle = direction.normalized().y
			swipe_finished = true

func _physics_process(delta):
	velocity.x = player_velocity
	elapsed_time += delta
	if direction.y < -swipe_distance and swipe_finished == true and swipe_angle < -swipe_angle_const:
		#velocity.y += JUMP_SPEED
		swipeup = true
		swipe_finished = false
	if direction.y > swipe_distance and swipe_finished == true and swipe_angle > swipe_angle_const:
		swipedown = true
		#velocity.y -= JUMP_SPEED
		swipe_finished = false
	if direction.x > swipe_distance and swipe_finished == true and swipe_angle < swipe_angle_const/3:
		swiperight = true
		swipe_finished = false
	velocity.y += GRAVITY  
	velocity = move_and_slide(velocity, FLOOR)
	
	if (get_slide_count()>0):
		print(get_slide_collision(0).collider.name)
		if (get_slide_collision(0).collider.name == "KinematicBody2D" or get_slide_collision(0).collider.name == "@KinematicBody2D@3"):
			dead = true


	if (swipeup and onground and !sliding):
		velocity.y += JUMP_SPEED
		jumping = true
		swipeup = false
		
	if (swipedown and onground):
		$slideCollision.disabled = false
		$runCollision.disabled = true
		$dashCollision.disabled = true
		sliding = true
		onground = true
		falling = false
		jumping = false
		running = false
		swipedown = false
		slide_start = self.position.x
	if (swipedown and !onground):
		velocity.y -= JUMP_SPEED*2
		falling = true
		swipedown = false
	if (swipeup and onground and sliding):
		$runCollision.disabled = false
		$dashCollision.disabled = true
		$slideCollision.disabled = true
		jumping = false
		sliding = false
	if (swiperight and onground and !sliding and !jumping and !falling):
		$dashCollision.disabled = false
		$runCollision.disabled = true
		$slideCollision.disabled = true
		dash_start = self.position.x
		running = false
		dashing = true
		swiperight = false
	if (swiperight and (jumping or falling) and canDash):
		$dashCollision.disabled = false
		$runCollision.disabled = true
		$slideCollision.disabled = true
		dash_start = self.position.x
		temp_y_velocity = velocity.y
		if (jumping):
			temp_state = jumping
		else:
			temp_state = falling
		jumping = false
		falling = false
		dashing = true
		canDash = false
		swiperight = false
	if (swiperight and sliding):
		$runCollision.disabled = true
		$slideCollision.disabled = true
		$dashCollision.disabled = false
		dash_start = self.position.x
		sliding = false
		dashing = true
		swiperight = false
		sliding = false
		
	if (sliding):
		slide_end = (self.position.x)
		if (slide_end - slide_start > slide_distance):
			$runCollision.disabled = false
			$dashCollision.disabled = true
			$slideCollision.disabled = true
			sliding = false
			
	if (dashing):
		dash_end = self.position.x
		player_velocity = dash_velocity
		velocity.y = 0
		if (dash_end - dash_start > dash_distance):
			$runCollision.disabled = false
			$dashCollision.disabled = true
			$slideCollision.disabled = true
			player_velocity = 150
			velocity.y = temp_y_velocity
			dashing = false
			if (temp_state == falling):
				falling = true
			elif (temp_state == jumping):
				jumping = true
	
	if velocity.y < 0:
		jumping = true
		sliding = false
		running = false
	elif velocity.y > 0:
		falling = true
		running = false
		jumping = false
	else:
		falling = false
		jumping = false
		
	if (!jumping and !falling and !sliding and !dashing):
		running = true
		
	if (is_on_floor()):
		onground = true
		canDash = true
	else:
		onground = false
	
	if (jumping):
		$PlayerSprite.play("ninjaJump")
	elif (falling):
		$PlayerSprite.play("ninjaFall")
	elif (running):
		$PlayerSprite.play("ninjaRun")
	elif (sliding):
		$PlayerSprite.play("ninjaSlide")
	elif (dashing):
		$PlayerSprite.play("ninjaDash")

