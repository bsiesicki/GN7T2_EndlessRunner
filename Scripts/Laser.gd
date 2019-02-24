extends Node

# Szybkość rotacji
var rotation_speed = 1
# pozycja lasera na osi X
var platform_position_x = 80
var platform_position_x2 = 240
# pozycja lasera na osi Y
var platform_position_y = 50

#poruszanie się platformy
var platform_speed = 20
var platform_dir = 1
var speed = Vector2()
#kąt startowy do obrotu
var angle = 1.570796

const laser_scn = preload("res://Laser.tscn")

onready var node2d
onready var node2d2
onready var node2dkb
onready var node2d2kb
var node2d3

func _ready():
	#wyciągnięcie nodów do zmiennych
	node2d = get_node("Node2D")
	node2d2 = get_node("Node2D2")
	node2d2kb = get_node("Node2D2/KinematicBody2D")
	node2dkb = get_node("Node2D/KinematicBody2D")
	node2d3 = laser_scn.instance()
	node2d3.position = Vector2(50.0,150)
	add_child(node2d3)
	#ustawienie poczatkowego konta obrotu
	node2d.rotation = angle
	pass

func _physics_process(delta):
	node2d.rotation += -1 * delta * rotation_speed
	#node2d2.rotation += 1 * delta * rotation_speed
	node2d.position = Vector2(platform_position_x, platform_position_y)
	node2d2.position = Vector2(platform_position_x2, platform_position_y)
	speed.y = platform_speed*platform_dir*delta
	node2d2kb.move_and_collide(speed)
	#print(node2d2kb.position.y)
	if (node2d2kb.position.y > 120):
		platform_dir = -1
	elif (node2d2kb.position.y < 30):
		platform_dir = 1
	pass

