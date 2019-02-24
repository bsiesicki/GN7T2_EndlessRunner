extends KinematicBody2D

var vertical_direction = 0 #1 w dół, -1 w górę
var horizontal_direction = 1 #1 w prawo, -1 w lewo
var speed = 0
const ACCELERATION = 1
var velocity = 0
var platform 
var rotation_speed
var rot
var movement = Vector2()




func _ready():
	set_physics_process(true)
	pass
	
func _physics_process(delta):
	vertical_direction = 1
	speed += ACCELERATION * delta
	rotation_speed += 10*ACCELERATION * delta
	velocity = speed * delta * horizontal_direction
	rot = rotation_speed * delta * vertical_direction
	movement = Vector2(velocity,0).rotated(rot)
	move_and_collide(movement)
	pass