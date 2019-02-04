extends KinematicBody2D

const GRAVITY = 10
const JUMP_SPEED = -250
const JUMP_MAX_AIRBORNE_TIME = 0.2
const FLOOR = Vector2(0, -1)

var on_air_time = 100
var jumping = false
var prev_jump_pressed = false
var player_speed = 200
var velocity = Vector2()
var elapsed_time = 0    
var start
var speed
var start_time
var direction = Vector2()
var swipe_finished = false

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
            direction = direction.normalized()
            swipe_finished = true
            print(direction.y)

func _physics_process(delta):
    elapsed_time += delta
    if direction.y < 0 and swipe_finished == true:
        velocity.y += JUMP_SPEED
        swipe_finished = false
    if direction.y > 0 and swipe_finished == true:
        velocity.y -= JUMP_SPEED
        swipe_finished = false
    velocity.y += GRAVITY  
    velocity = move_and_slide(velocity, FLOOR)
    print(velocity)
