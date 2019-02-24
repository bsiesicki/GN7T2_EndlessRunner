extends KinematicBody2D

var vertical_direction = 0 #1 w dół, -1 w górę
var horizontal_direction = 0
var speed = 0
const ACCELERATION = 20
var velocity = 0


func _ready():
	set_process(true)
	pass
	
func _process(delta):
	vertical_direction = 1
	speed += ACCELERATION * delta
	velocity = speed * delta * vertical_direction
	move_and_collide(Vector2(0,velocity))
	pass