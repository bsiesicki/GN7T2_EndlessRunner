extends KinematicBody2D

var rotation_rate = 0
var start_position
var dest_position
var vector
var collision
var distance

func pause(x):
	 self.set_physics_process(x)

func _ready(starting_position, vect, starting_distance, rot=0):
	self.position = starting_position
	distance = starting_distance
	start_position = self.position
	vector = vect
	dest_position = start_position + (distance / 2 * vect.normalized())
	if(rot == 0):
		rotation = PI/2 * randf()
	else:
		rotation = rot
	pass

func reappear(new_position, vect, dist):
	self.position = new_position + Vector2(0, rand_range(-10,30))
	start_position = position
	vector = vect
	distance = dist
	dest_position = start_position + (distance / 2 * vector.normalized())
	self.rotation = randf()*(PI/2)
	rotation_rate += 0.05
	

func _physics_process(delta):
	if(self.start_position.x < dest_position.x):
		if(self.position.x > dest_position.x):
			vector = Vector2(-vector.x, vector.y)
		if(self.position.x < start_position.x):
			vector = Vector2(-vector.x, vector.y)
	else:
		if(self.position.x < dest_position.x):
			vector = Vector2(-vector.x, vector.y)
		if(self.position.x > start_position.x):
			vector = Vector2(-vector.x, vector.y)
			
	if(self.start_position.y < dest_position.y):
		if(self.position.y > dest_position.y):
			vector = Vector2(vector.x, -vector.y)
		if(self.position.y < start_position.y):
			vector = Vector2(vector.x, -vector.y)
	else:
		if(self.position.y < dest_position.y):
			vector = Vector2(vector.x, -vector.y)
		if(self.position.y > start_position.y):
			vector = Vector2(vector.x, -vector.y)
			
	self.rotate(rotation_rate * delta)
	collision = move_and_collide(vector)
	
	pass
	
