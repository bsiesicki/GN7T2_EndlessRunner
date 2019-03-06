extends KinematicBody2D

const GRAVITY = 10
const JUMP_MAX_AIRBORNE_TIME = 0.2
const FLOOR = Vector2(0, -1)

enum State {RUNNING, SLIDING, JUMPING, FALLING, DASHING, SKYDASHING, STOP}
enum Swipe {LEFT, RIGHT, UP, DOWN, BLANK}

export (int) var on_air_time = 100
export (int) var slide_distance = 140
export (int) var dash_distance = 130
export (int) var player_velocity = 150
export (int) var dash_velocity = 450
export (int) var JUMP_SPEED = -350
export (State) var state = RUNNING
export (Swipe) var swipe = BLANK

var velocity = Vector2()
var elapsed_time = 0    
var prev_jump_pressed = false
var slide_start = 0
var slide_end = 0
var dash_start = 0
var dash_end = 0
var dead = false
var canDash = true

func pause(x):
	self.set_physics_process(x)
	if(x == false):
		$PlayerSprite.stop()
	else:
		$PlayerSprite.play('ninjaRun')

	

func _ready():
	$slideCollision.disabled = true
	$dashCollision.disabled = true
	$PlayerSprite.play('ninjaFall')
	velocity.x = player_velocity

func set_swipe(swipe_dir):
	swipe = swipe_dir
	
func _physics_process(delta):
	elapsed_time += delta
	velocity = move_and_slide(velocity, FLOOR)
	
	if (get_slide_count()!=0):
		for i in range (0,get_slide_count()) :
			var collider = get_slide_collision(i).collider
			if (collider.is_class("KinematicBody2D")):
				dead = true

	if (swipe == DOWN):
		if (state == RUNNING):
			state = SLIDING
			slide_start = self.position.x

		elif (state == JUMPING or state == SKYDASHING or state == FALLING):
			velocity.y -= JUMP_SPEED*2
			velocity.x = player_velocity
			state = FALLING
		swipe = BLANK

	if (swipe == UP):
		if (state == RUNNING or state == SLIDING):
			velocity.y += JUMP_SPEED
			state = JUMPING
		swipe = BLANK

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
		if($PlayerSprite.is_playing()):
			$PlayerSprite.play("ninjaJump")
		$slideCollision.disabled = true
		$dashCollision.disabled = true
		$jumpCollision.disabled = false
		$fallCollision.disabled = true
		$runCollision.disabled = true
	elif (state == FALLING):
		if($PlayerSprite.is_playing()):
			$PlayerSprite.play("ninjaFall")
		$slideCollision.disabled = true
		$dashCollision.disabled = true
		$jumpCollision.disabled = true
		$fallCollision.disabled = false
		$runCollision.disabled = true
	elif (state == RUNNING):
		if($PlayerSprite.is_playing()):
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
		if($PlayerSprite.is_playing()):
			$PlayerSprite.play("ninjaSlide")
	elif (state == DASHING or state ==SKYDASHING):
		if($PlayerSprite.is_playing()):
			$PlayerSprite.play("ninjaDash")
		$slideCollision.disabled = true
		$dashCollision.disabled = false
		$jumpCollision.disabled = true
		$fallCollision.disabled = true
		$runCollision.disabled = true