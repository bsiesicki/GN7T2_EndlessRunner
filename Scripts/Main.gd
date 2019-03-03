extends Node

onready var character
onready var indicator
onready var highscore_indicator
onready var pause_menu
onready var laser_instance
onready var laser_instance2
onready var camera
onready var platform_instance
onready var bgm
onready var settings_instance
onready var global

var score_file = "user://highscore.txt"
var highscore = 0

const dist_scale = 40

var laser_movement_vector = Vector2(0,0)
var laser_movement_distance = 100
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

func _ready():
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
		bgm = get_node("AudioStreamPlayer2D")
		bgm.volume_db = -30
		bgm.play(0)

	get_tree().paused = false
	laser_instance = laser.instance()
	laser_instance._ready(Vector2(900, 90), laser_movement_vector, laser_movement_distance)
	
	laser_instance2 = laser.instance()
	laser_instance2._ready(Vector2(1200, 110), laser_movement_vector, laser_movement_distance)
	
	platform_instance = platform.instance()
	platform_instance.position = Vector2(500 ,130)

	self.add_child(platform_instance)
	self.add_child(laser_instance)
	self.add_child(laser_instance2)
	pass

func _physics_process(delta):
	#Przemierzony dystans
	var current_camera_position = camera.position
	indicator.text = "CURRENT SCORE: " + str((int(character.position.x)/dist_scale)) + " m"
	
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
