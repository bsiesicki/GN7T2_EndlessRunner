extends Node

onready var character
onready var indicator
onready var laser_instance
onready var camera
onready var platform_instance
onready var platform_instance2

const dist_scale = 40

var laser_movement_vector = Vector2(0,0)
var laser_movement_distance = 100
var platform = preload("res://Scenes/platform.tscn")
var laser = preload("res://Scenes/laser.tscn")


func _ready():
	character = get_node("Player")
	indicator = get_node("DistanceIndicator/Label")
	camera = get_node("Camera2D")

	
	laser_instance = laser.instance()
	laser_instance._ready(Vector2(600, 100), laser_movement_vector, laser_movement_distance)
	platform_instance = platform.instance()
	platform_instance2 = platform.instance()
	platform_instance.position = Vector2(150,130)
	platform_instance2.position = Vector2(350,130)
	self.add_child(platform_instance)
	self.add_child(platform_instance2)
	self.add_child(laser_instance)
	pass

func _physics_process(delta):
	#Przemierzony dystans
	var current_camera_position = camera.position
	indicator.text = str((int(character.position.x)/dist_scale)) + " m"
	if laser_instance.position < current_camera_position - Vector2(300, 0):
		laser_movement_distance = 150 - randf()*100
		laser_movement_vector = current_camera_position.x / 100000 * Vector2(randf(),randf())
		laser_instance.reappear(camera.position, laser_movement_vector, laser_movement_distance)
	platform_instance.reappear(camera, randf()*30+1)
	platform_instance2.reappear(camera, randf()*30+1)
	pass
