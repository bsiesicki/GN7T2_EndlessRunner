extends Node

onready var character
onready var indicator
onready var laser_instance
onready var laser_instance2
onready var camera
onready var platform_instance

const dist_scale = 40

var laser_movement_vector = Vector2(0,0)
var laser_movement_distance = 100
var platform = preload("res://Scenes/platform.tscn")
var laser = preload("res://Scenes/laser.tscn")


func _ready():
	randomize()
	character = get_node("Player")
	indicator = get_node("DistanceIndicator/Label")
	camera = get_node("Camera2D")

	get_tree().paused = false
	laser_instance = laser.instance()
	laser_instance._ready(Vector2(900, 90), laser_movement_vector, laser_movement_distance)
	
	laser_instance2 = laser.instance()
	laser_instance2._ready(Vector2(1200, 100), laser_movement_vector, laser_movement_distance)
	
	platform_instance = platform.instance()
	platform_instance.position = Vector2(500 ,130)

	self.add_child(platform_instance)
	self.add_child(laser_instance)
	self.add_child(laser_instance2)
	pass

func _physics_process(delta):
	#Przemierzony dystans
	var current_camera_position = camera.position
	indicator.text = str((int(character.position.x)/dist_scale)) + " m"
	
	if laser_instance.position < current_camera_position - Vector2(300, 0):
		laser_movement_distance = 150 - randf()*100
		laser_movement_vector = current_camera_position.x / 100000 * Vector2(randf()*2-1,randf()*2-1)
		laser_instance.reappear(camera.position, laser_movement_vector, laser_movement_distance)
	
	if laser_instance2.position < current_camera_position - Vector2(300, 0):
		laser_movement_distance = 150 - randf()*100
		laser_movement_vector = current_camera_position.x / 100000 * Vector2(randf()*2-1,randf()*2-1)
		laser_instance2.reappear(camera.position, laser_movement_vector, laser_movement_distance)
	
	platform_instance.reappear(camera, randf()*30+1)
	
	if (character.dead == true):
		get_tree().paused = true
		get_node("gameOverMenu/gameOverPopup").show()
	pass
	


func _on_retryButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_giveUpButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

