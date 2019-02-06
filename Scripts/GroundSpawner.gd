# script: spawner_ground

extends Node2D

const scn_ground   = preload("res://Scenes/Ground.tscn")
const GROUND_WIDTH = 168*2
const AMOUNT_TO_FILL_VIEW = 2

var currentPosition = Vector2(0, 0)

func _ready():
	for i in range(AMOUNT_TO_FILL_VIEW):
		spawn_and_move()
	pass

func spawn_and_move():
	spawn_ground()
	go_next_pos()
	pass

func spawn_ground():
	currentPosition.y = self.global_position.y
	var new_ground = scn_ground.instance()
	new_ground.set("position", currentPosition)
	new_ground.connect("tree_exited", self, "spawn_and_move")
	$container.add_child(new_ground)
	#print(new_ground.get("position"))
	pass

func go_next_pos():
	currentPosition += Vector2(GROUND_WIDTH, 0)
	pass