extends KinematicBody2D


const GRAVITY = 10
export (int) var JUMP_SPEED = -350
const JUMP_MAX_AIRBORNE_TIME = 0.2
const FLOOR = Vector2(0, -1)

enum State {RUNNING, SLIDING, JUMPING, FALLING, DASHING, SKYDASHING}
enum Swipe {LEFT, RIGHT, UP, DOWN, BLANK}


var on_air_time = 100

export (State) var state = RUNNING
export (Swipe) var swipe = BLANK

var prev_jump_pressed = false
var slide_start = 0
var slide_end = 0
var dash_start = 0
var dash_end = 0
var dead = false
var canDash = true
export (int) var slide_distance = 140
export (int) var dash_distance = 130
export (int) var player_velocity = 150
export (int) var dash_velocity = 450
var temp_state 
var temp_y_velocity = 0
var velocity = Vector2()
var elapsed_time = 0    
var start
var speed
var swipe_angle
#var dash_disabled = true
#var slide_disabled = true
#var jump_disabled = true

var direction = Vector2()
export (float) var swipe_angle_const = 0.75
var swipe_finished = false
export (int) var swipe_distance = 50

func _ready():
	$slideCollision.disabled = true
	$dashCollision.disabled = true
	velocity.x = player_velocity
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			start = event.position
		else:
			direction = event.position - start
			swipe_angle = direction.normalized().y
			swipe_finished = true

func _physics_process(delta):
	elapsed_time += delta

	velocity = move_and_slide(velocity, FLOOR)
	
	if (get_slide_count()>0):
		var collider = get_slide_collision(0).collider
		if (collider.is_class("KinematicBody2D")):
			dead = true
		if (get_slide_collision(1) != null):
			var collider2 = get_slide_collision(1).collider
			if (collider2.is_class("KinematicBody2D")):
				dead = true


	if direction.y < -swipe_distance and swipe_finished == true and swipe_angle < -swipe_angle_const:
		swipe = UP
		swipe_finished = false

	elif direction.y > swipe_distance and swipe_finished == true and swipe_angle > swipe_angle_const:
		swipe = DOWN
		swipe_finished = false

	elif direction.x > swipe_distance and swipe_finished == true and swipe_angle < swipe_angle_const/3:
		swipe = RIGHT
		swipe_finished = false
#	if(swipe != BLANK):
#		print(swipe)
	
	#if (swipe == DOWN and !slide_disabled):
	if (swipe == DOWN):
		if (state == RUNNING):
			state = SLIDING
			slide_start = self.position.x
		
		elif (state == JUMPING or state == SKYDASHING):
			velocity.y -= JUMP_SPEED*2
			velocity.x = player_velocity
			state = FALLING
		swipe = BLANK

	#if (swipe == UP and !jump_disabled):
	if (swipe == UP):
		if (state == RUNNING or state == SLIDING):
			velocity.y += JUMP_SPEED
			state = JUMPING
		swipe = BLANK
		
	#if (swipe == RIGHT and !dash_disabled):
	if (swipe == RIGHT):
		if(canDash):
			dash_start = self.position.x
			if(state == JUMPING or state == FALLING):
				state = SKYDASHING
				canDash = false
			else:
				state = DASHING
		swipe = BLANK
		
	if (state == SLIDING):
		slide_end = self.position.x
		if (slide_end - slide_start > slide_distance):

			state = RUNNING
			
	elif (state == DASHING or state == SKYDASHING):
		dash_end = self.position.x
		velocity.x = dash_velocity
		velocity.y = 0
		if (dash_end - dash_start > dash_distance):
			velocity.x = player_velocity
			velocity.y = 0
			if (state == DASHING):
				state = RUNNING
			else:
				state = FALLING

	if velocity.y > 0:
		state = FALLING

	if (is_on_floor()):
		canDash = true
		if(state == FALLING):
			velocity.y = 0
			velocity.x = player_velocity
			state = RUNNING
	else:
		velocity.y += GRAVITY 
		
	if (state == JUMPING):
		$PlayerSprite.play("ninjaJump")
		$slideCollision.disabled = true
		$dashCollision.disabled = true
		$jumpCollision.disabled = false
		$fallCollision.disabled = true
		$runCollision.disabled = true
	elif (state == FALLING):
		$PlayerSprite.play("ninjaFall")
		$slideCollision.disabled = true
		$dashCollision.disabled = true
		$jumpCollision.disabled = true
		$fallCollision.disabled = false
		$runCollision.disabled = true
	elif (state == RUNNING):
		$PlayerSprite.play("ninjaRun")
		$slideCollision.disabled = true
		$dashCollision.disabled = true
		$jumpCollision.disabled = true
		$fallCollision.disabled = true
		$runCollision.disabled = false
	elif (state == SLIDING):
		$dashCollision.disabled = true
		$jumpCollision.disabled = true
		$fallCollision.disabled = true
		$runCollision.disabled = true
		$slideCollision.disabled = false
		$PlayerSprite.play("ninjaSlide")
	elif (state == DASHING or state ==SKYDASHING):
		$PlayerSprite.play("ninjaDash")
		$slideCollision.disabled = true
		$dashCollision.disabled = false
		$jumpCollision.disabled = true
		$fallCollision.disabled = true
		$runCollision.disabled = true
		