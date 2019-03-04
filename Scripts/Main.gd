extends Node

onready var character
onready var indicator
onready var highscore_indicator
onready var pause_menu
onready var object0
onready var object1
onready var object2
onready var object3
onready var object4
onready var object5
onready var camera
onready var platform_instance
onready var bgm
onready var settings_instance
onready var global

const laser_movement_speed_decreaser = 50000
const object_spawn_distance = 200
const dist_scale = 40

var current_camera_position
var score_file = "user://highscore.txt"
var highscore = 0
var object_movement_vector = Vector2(0,0)
var object_movement_distance = 100
var platform = preload("res://Scenes/platform.tscn")
var laser = preload("res://Scenes/laser.tscn")
var settings = preload("res://Scenes/Settings.tscn")

func load_score():
    var f = File.new()
    if f.file_exists(score_file):
        f.open(score_file, File.READ)
        var content = f.get_as_text()
        highscore = int(content)
        f.close()

func random_object():
	var rand = randf()
	if(rand > 0.2):
		return laser.instance()
	else:
		return platform.instance()
	pass
	
func _ready():
	get_tree().paused = false
	randomize()
	load_score()
	global = get_node("/root/global")
	global.load_settings()
	character = get_node("Player")
	indicator = get_node("DistanceIndicator/VBoxContainer/currentDistance")
	pause_menu = get_node("PauseMenu")
	highscore_indicator = get_node("DistanceIndicator/VBoxContainer/bestScore")
	highscore_indicator.text = str("BEST SCORE: " + str(highscore)) + " m"
	camera = get_node("Camera2D")
	settings_instance = settings.instance()
	if (global.music == true):
		bgm = get_node("Camera2D/bgm")
		bgm.volume_db = -30.0
		bgm.play(0)
		
	object0 = platform.instance()
	object0.position = Vector2(500,130)
	
	object1 = laser.instance()
	object1._ready(Vector2(900, 90), object_movement_vector, object_movement_distance)
	
	object2 = laser.instance()
	object2._ready(Vector2(1200, 70), Vector2(0,0.9), object_movement_distance)

	object3 = random_object()
	object4 = random_object()
	object5 = random_object()
	
	object3._ready(object2.position+Vector2(object_spawn_distance,0), object_movement_vector, object_movement_distance)
	object4._ready(object3.position+Vector2(object_spawn_distance,0), object_movement_vector, object_movement_distance)
	object5._ready(object4.position+Vector2(object_spawn_distance,0), object_movement_vector, object_movement_distance)
	
	self.add_child(object0)
	self.add_child(object1)
	self.add_child(object2)
	self.add_child(object3)
	self.add_child(object4)
	self.add_child(object5)

func _physics_process(delta):
	#Przemierzony dystans
	current_camera_position = camera.position
		
	indicator.text = "CURRENT SCORE: " + str((int(character.position.x)/dist_scale)) + " m"
	
	if object0.position.x < current_camera_position.x - 299:
		object0 = manage_object(object5.position, object0)
		add_child(object0)
	
	if object1.position.x < current_camera_position.x - 300:
		object1 = manage_object(object0.position, object0)
		add_child(object1)
		
	if object2.position.x < current_camera_position.x - 300:
		object2 = manage_object(object1.position, object0)
		add_child(object2)
		
	if object3.position.x < current_camera_position.x - 300:
		object3 = manage_object(object2.position, object0)
		add_child(object3)
	
	if object4.position.x < current_camera_position.x - 300:
		object4 = manage_object(object3.position, object0)
		add_child(object4)
	
	if object5.position.x < current_camera_position.x - 300:
		object5 = manage_object(object4.position, object0)
		add_child(object5)
	
	
	
	if (character.dead == true):
		if (global.music == true):
			bgm.volume_db = -40.0
		get_tree().paused = true
		get_node("gameOverMenu/gameOverPopup").show()
		if ((int(character.position.x)/dist_scale)>highscore):
			highscore = int(character.position.x)/dist_scale
		save_score()
	pass
	
	###################################Tutorial 1 trigger
#	if (int(character.position.x) == 350):
#		startTut1()
func manage_object(position, objectx):
	object_movement_distance = rand_range(50,150)
	object_movement_vector = current_camera_position.x / laser_movement_speed_decreaser * Vector2(randf()*2-1,randf()*2-1)
	objectx = random_object()
	objectx.reappear(Vector2(position.x,90)+Vector2(object_spawn_distance,0), object_movement_vector, object_movement_distance)
	return objectx

func _on_retryButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_giveUpButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
func save_score():
    var f = File.new()
    f.open(score_file, File.WRITE)
    f.store_string(str(highscore))
    f.close()

#######################################Tutorial 1 funcion
#func startTut1():
#	get_tree().paused = true
#	get_node("jumpTut/Container").show()
#	get_node("jumpTut/Container/swipeUp/swipeUpAnim").play()
#	if (character.swipe == UP):
#		character.jump_disabled = false
#		get_tree().paused = false
#		get_node("jumpTut/Container").hide()
#		get_node("jumpTut/Container/swipeUp/swipeUpAnim").stop()
