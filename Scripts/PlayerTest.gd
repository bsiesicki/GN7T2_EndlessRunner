extends KinematicBody2D

const GRAVITY = 10
const JUMP_SPEED = -350
const JUMP_MAX_AIRBORNE_TIME = 0.2
const FLOOR = Vector2(0, -1)

enum State {RUNNING, SLIDING, JUMPING, FALLING}
enum Swipe {LEFT, RIGHT, UP, DOWN, BLANK}

var on_air_time = 100
var swipeup = false
var swipedown = false
var jumping = false
var sliding = false
var falling = false
var running = true
var onground = true
var prev_jump_pressed = false
var player_speed = 200
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
			speed = (direction.length())/(elapsed_time - start_time)
			#direction = direction.normalized()
			swipe_angle = direction.normalized().y
			swipe_finished = true
			print(direction, swipe_angle)

func _physics_process(delta):
	elapsed_time += delta
	if direction.y < -swipe_distance and swipe_finished == true and swipe_angle < -swipe_angle_const:
		#velocity.y += JUMP_SPEED
		swipeup = true
		swipe_finished = false
	if direction.y > swipe_distance and swipe_finished == true and swipe_angle > swipe_angle_const:
		swipedown = true
		#velocity.y -= JUMP_SPEED
		swipe_finished = false
	velocity.y += GRAVITY  
	velocity = move_and_slide(velocity, FLOOR)
	#print(onground)

	if (swipeup and onground and !sliding):
		print("Jump.")
		velocity.y += JUMP_SPEED
		jumping = true
		swipeup = false
	if (swipedown and onground):
		print("Slide.")
		sliding = true
		falling = false
		jumping = false
		running = false
		swipedown = false
	if (swipedown and !onground):
		print("SMASH!")
		velocity.y -= JUMP_SPEED*2
		falling = true
		swipedown = false
	if (swipeup and onground and sliding):
		print("Slide end test")
		jumping = false
		sliding = false
	
	
	if velocity.y < 0:
		jumping = true
		sliding = false
		running = false
	elif velocity.y > 0:
		falling = true
		jumping = false
	else:
		falling = false
		jumping = false
		
	if (!jumping and !falling and !sliding):
		running = true
		
	if (is_on_floor()):
		onground = true
	else:
		onground = false
	
	if (jumping):
		$PlayerSprite.play("jump")
	elif (falling):
		$PlayerSprite.play("fall")
	elif (running):
		$PlayerSprite.play("run")
	elif (sliding):
		$PlayerSprite.play("slide")

