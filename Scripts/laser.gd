extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var startPosition
var destPosition
var vec 
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	startPosition = self.position
	move_and_slide(Vector2(0,0))
	add_collision_exception_with(get_tree())
	pass

func move(destination):
	destPosition = destination


func rotate(rotation_rate):
	self.rotation = self.rotation + 1 * rotation_rate
	pass
	
func reappear(camera, x):

	if self.position < camera.position - Vector2(300,0):
		self.position = camera.position + Vector2(170+x,randf()*90-39)

func _process(delta):
	if(startPosition != destPosition):
		if (position != destPosition):
			move_and_collide(destPosition-position/100)
		else:
			move_and_collide(startPosition-position/100)
			
	
	print(self.position)
#	if (get_slide_count()>0):
#		if(get_slide_collision(0).collider.name == 'Player'):
#			get_tree().paused = false
#			print("laser")
	pass
	
