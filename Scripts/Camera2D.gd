extends Camera2D

onready var player = get_parent().get_node("Player")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	self.position.x = player.position.x + 120
	#print(self.position, self.global_position)
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
