extends Node

enum Swipe {LEFT, RIGHT, UP, DOWN, BLANK}

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

export (Swipe) var swipe = BLANK
export (float) var swipe_angle_const = 0.75
export (int) var swipe_distance = 50

var current_camera_position
var save_file = "user://data.json"
var save_data = {highscore = 0,
	has_finished_tutorial = false}
var object_movement_vector = Vector2(0,0)
var object_movement_distance = 100
var platform = preload("res://Scenes/platform.tscn")
var laser = preload("res://Scenes/laser.tscn")
var settings = preload("res://Scenes/Settings.tscn")
var start
var swipe_angle
var swipe_finished = false
var direction = Vector2()

func _ready():
	
	load_score()
	
	add_user_signal("UP")
	add_user_signal("DOWN")
	add_user_signal("RIGHT")

	get_tree().paused = false

	global = get_node("/root/global")
	global.load_settings()
	character = get_node("Player")
	indicator = get_node("DistanceIndicator/VBoxContainer/currentDistance")
	pause_menu = get_node("PauseMenu")
	highscore_indicator = get_node("DistanceIndicator/VBoxContainer/bestScore")
	highscore_indicator.text = str("BEST SCORE: " + str(save_data['highscore'])) + " m"
	camera = get_node("Camera2D")
	settings_instance = settings.instance()

	if (global.music == true):
		bgm = get_node("Camera2D/bgm")
		bgm.volume_db = -30.0
		bgm.play(0)

	object0 = platform.instance()
	object0.position = Vector2(500,130)
	
	object1 = laser.instance()
	object1._ready(Vector2(900, 90), object_movement_vector, object_movement_distance,PI)
	
	object2 = laser.instance()
	object2._ready(Vector2(1200, 90), Vector2(0,0.98), object_movement_distance + 40, PI/2)

	object3 = laser.instance()
	object3._ready(Vector2(1400, 50), Vector2(0,0), object_movement_distance , PI)
	
	randomize()
	object4 = random_object()
	object5 = random_object()
	

	object4._ready(object3.position+Vector2(object_spawn_distance,50), object_movement_vector, object_movement_distance)
	object5._ready(object4.position+Vector2(object_spawn_distance,50), object_movement_vector, object_movement_distance)
	
	self.add_child(object0)
	self.add_child(object1)
	self.add_child(object2)
	self.add_child(object3)
	self.add_child(object4)
	self.add_child(object5)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			start = event.position
		else:
			direction = event.position - start
			swipe_angle = direction.normalized().y
			swipe_finished = true

	if direction.y < -swipe_distance and swipe_finished == true and swipe_angle < -swipe_angle_const:
		swipe = UP
		emit_signal('UP')
		swipe_finished = false
	elif direction.y > swipe_distance and swipe_finished == true and swipe_angle > swipe_angle_const:
		swipe = DOWN
		emit_signal('DOWN')
		swipe_finished = false
	elif direction.x > swipe_distance and swipe_finished == true and swipe_angle < swipe_angle_const/3:
		swipe = RIGHT
		emit_signal('RIGHT')
		swipe_finished = false

func _physics_process(delta):
	#Przemierzony dystans
	if(save_data['has_finished_tutorial']):
		character.set_swipe(swipe)
		swipe=BLANK

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
		play_dead()
		if (global.music == true):
			bgm.volume_db = -40.0
		get_tree().paused = true
		get_node("gameOverMenu/gameOverPopup").show()
		if ((int(character.position.x)/dist_scale)>save_data['highscore']):
			save_data['highscore'] = int(character.position.x)/dist_scale
		save_data()

	if(!save_data['has_finished_tutorial']):
		if (int(character.position.x) == 350):
			start_jump_tutorial()
		if (int(character.position.x) == 850):
			start_slide_tutorial()
		if (int(character.position.x) == 1100):
			start_dash_tutorial()
		if (int(character.position.x) == 1300):
			character.set_swipe(Swipe.UP)
		if (int(character.position.x) == 1350):
			start_slam_tutorial()
			

func manage_object(position, objectx):
	object_movement_distance = rand_range(50,150)
	object_movement_vector = current_camera_position.x / laser_movement_speed_decreaser * Vector2(randf()*2-1,randf()*2-1)
	objectx = random_object()
	objectx.reappear(Vector2(position.x,100)+Vector2(object_spawn_distance,0), object_movement_vector, object_movement_distance)
	return objectx

func _on_retryButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_giveUpButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func play_dead():
	character.get_node("PlayerSprite").hide()
	character.get_node("DeathSprite").show()
	character.get_node("DeathSprite").play("ninjaDeath")

func start_jump_tutorial():
	character.pause(false)
	object2.pause(false)
	get_node("jumpTut/Container").show()
	get_node("jumpTut/Container/swipeUp/swipeUpAnim").play()
	yield(self, 'UP')
	object2.pause(true)
	character.set_swipe(swipe)
	character.pause(true)
	get_node("jumpTut/Container").hide()
	get_node("jumpTut/Container/swipeUp/swipeUpAnim").stop()
	
func start_slide_tutorial():
	character.pause(false)
	object2.pause(false)
	get_node("slideTut/Container").show()
	get_node("slideTut/Container/swipeDown/swipeDownAnim").play()
	yield(self, 'DOWN')
	object2.pause(true)
	character.set_swipe(swipe)
	character.pause(true)
	get_node("slideTut/Container").hide()
	get_node("slideTut/Container/swipeDown/swipeDownAnim").stop()

func start_dash_tutorial():
	character.pause(false)
	object2.pause(false)
	get_node("dashTut/Container").show()
	get_node("dashTut/Container/swipeRight/swipeRightAnim").play()
	yield(self, 'RIGHT')
	object2.pause(true)
	character.set_swipe(swipe)
	character.pause(true)
	get_node("dashTut/Container").hide()
	get_node("dashTut/Container/swipeRight/swipeRightAnim").stop()

func start_slam_tutorial():
	character.pause(false)
	get_node("slideTut/Container").show()
	get_node("slideTut/Container/slideText").text = "SWIPE DOWN WHILE IN MIDAIR FOR SLAM"
	get_node("slideTut/Container/swipeDown/swipeDownAnim").play()
	yield(self, 'DOWN')
	character.set_swipe(swipe)
	character.pause(true)
	get_node("slideTut/Container").hide()
	get_node("slideTut/Container/swipeDown/swipeDownAnim").stop()
	save_data['has_finished_tutorial'] = true

func load_score():
	var file = File.new()
	if not file.file_exists(save_file):
    	print("No file saved!")
    	return
	if file.open(save_file, File.READ) != 0:
		print("Error opening file")
		return
	save_data = parse_json(file.get_line())
	file.close()
	
func save_data():
	var file = File.new()
	if file.open(save_file, File.WRITE) != 0:
		print("Error opening file to save")
	file.store_string(to_json(save_data))
	file.close()

func random_object():
	var rand = randf()
	if(rand > 0.2):
		return laser.instance()
	else:
		return platform.instance()
