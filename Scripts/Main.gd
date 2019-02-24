extends Node

onready var character
onready var indicator
var dist_scale = 40
onready var platform1
onready var platform2
onready var platform3
var scale = Vector2(1.0,0.05)
var rotation_speed = 0.01
onready var camera

const laser_scn = preload("res://Laser.tscn")

func _ready():
	character = get_node("Player")
	indicator = get_node("DistanceIndicator/Label")
	platform1 = get_node("testLaser")
	platform2 = get_node("StaticBody2D2")
	platform3 = get_node("StaticBody2D3")
	camera = get_node("Camera2D")
	platform1.scale = scale
	platform2.scale = scale
	platform3.scale = scale
	pass

func _physics_process(delta):
	#Przemierzony dystans
	indicator.text = str((int(character.position.x)/dist_scale)) + " m"
#	for i in 100:
#		var node2d = laser_scn.instance()
#		if (int(character.position.x) == 200*i):
#			node2d.scale = scale
#			node2d.position = Vector2((character.position.x+150),100)
#			add_child(node2d)
	pass
