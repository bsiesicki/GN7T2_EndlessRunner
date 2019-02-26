extends KinematicBody2D

var rotation_rate
var start_position
var dest_position
var vect
var dist_scale = 100

func _ready(starting_position, vector, distance, starting_rotation_rate):
	self.position = starting_position
	start_position = self.position
	dest_position = start_position + (distance / 2 * vector.normalized())
	vect = vector
	rotation_rate = starting_rotation_rate
	pass

func reappear(current_camera_position):
	if self.position < current_camera_position - Vector2(300, 0):
		self.position = current_camera_position + Vector2(170 + randf()*100-1, randf()*30-1)
	#vect = Vector2(randf()*2-1, randf()*2-1)

func _process(delta):
	if(self.start_position.x < self.dest_position.x):
		if(self.position.x > dest_position.x):
			vect = Vector2(-vect.x, vect.y)
		if(self.position.x < start_position.x):
			vect = Vector2(-vect.x, vect.y)
	else:
		if(self.position.x < self.dest_position.x):
			vect = Vector2(-vect.x, vect.y)
		if(self.position.x > start_position.x):
			vect = Vector2(-vect.x, vect.y)
			
	if(self.start_position.y < self.dest_position.y):
		if(self.position.y > dest_position.y):
			vect = Vector2(vect.x, -vect.y)
		if(self.position.y < start_position.y):
			vect = Vector2(vect.x, -vect.y)
	else:
		if(self.position.y < dest_position.y):
			vect = Vector2(vect.x, -vect.y)
		if(self.position.y > start_position.y):
			vect = Vector2(vect.x, -vect.y)
	self.rotation += rotation_rate * delta
	move_and_slide(vect*50)

	pass
	
