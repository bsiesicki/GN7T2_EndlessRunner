extends Node

onready var character
onready var indicator
var dist_scale = 40
onready var platform1
onready var platform2
onready var platform3

func _ready():
	character = get_node("Player")
	indicator = get_node("DistanceIndicator/Label")
	platform1 = get_node("testLaser")
	platform2 = get_node("StaticBody2D2")
	platform3 = get_node("StaticBody2D3")
	platform1.scale = Vector2(1.0,0.05)
	pass

func _physics_process(delta):
	indicator.text = str((int(character.position.x)/dist_scale)) + " m"
	pass
