extends StaticBody2D

# Szybkość rotacji
var rotation_speed = 1
# pozycja lasera na osi X
var platform_position_x = 80
# pozycja lasera na osi Y
var platform_position_y = 50

#poruszanie się platformy
var platform_speed = 20
var platform_dir = 1
var speed = Vector2()
#kąt startowy do obrotu
var angle = 1.570796
var coll
func reappear(camera, x):
	if self.position < camera.position - Vector2(300,0):
		self.position = camera.position + Vector2(170+x,randf()*90-39)

func _ready():
	#wyciągnięcie nodów do zmiennych
	#node2d3 = laser_scn.instance()
	#node2d3.position = Vector2(50.0,150)
	#add_child(node2d3)

	#remove_collision_exception_with(get_tree().root.get_node('Player'))
	pass

func _physics_process(delta):
	

	#if (>0):
	#		print(get_node('KinematicBodyDown').get_slide_collision(0).collider.name )
	#	if(get_node('KinematicBodyDown').get_slide_collision(0).collider.name == 'Player'):
	#		get_tree().paused = false
	pass

