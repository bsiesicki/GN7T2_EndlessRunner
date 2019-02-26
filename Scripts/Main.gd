extends Node

onready var character
onready var indicator
var dist_scale = 40
var scale = Vector2(1.0,0.05)
var rotation_speed = 0.01
onready var camera
var platforma = preload("res://Scenes/platform.tscn")
var laser = preload("res://Scenes/laser.tscn")
var platforma_instance
var platforma_instance2
var laser_instance
func _ready():
	character = get_node("Player")
	indicator = get_node("DistanceIndicator/Label")
	camera = get_node("Camera2D")
	
	laser_instance = laser.instance()
	laser_instance._ready(Vector2(100,100),Vector2(0.2,0.2), 200, randf()*2-1)
	platforma_instance = platforma.instance()
	platforma_instance2 = platforma.instance()
	platforma_instance.position = Vector2(150,130)
	platforma_instance2.position = Vector2(350,130)
	self.add_child(platforma_instance)
	self.add_child(platforma_instance2)
	self.add_child(laser_instance)
	pass

func _physics_process(delta):
	#Przemierzony dystans
	indicator.text = str((int(character.position.x)/dist_scale)) + " m"
	laser_instance.reappear(camera.position)
	platforma_instance.reappear(camera, randf()*30+1)
	platforma_instance2.reappear(camera, randf()*30+1)
	pass
