extends StaticBody2D

onready var topRight = get_node("topRight")
onready var camera = get_tree().root.get_child(1).get_node("Camera2D")
onready var groundSpawner = get_tree().root.get_child(1).get_node("GroundSpawner")

func _ready():
	set_process(true)
	pass

func _process(delta):
	if camera == null: 
		print("No Camera Node")
		return
	
	#print("topRight: ", topRight.global_position.x)
	#print("camera: ", camera.position.x)
	
	
	if topRight.global_position.x <= camera.position.x - 200:
		queue_free()
		emit_signal("tree_exited");
	pass
