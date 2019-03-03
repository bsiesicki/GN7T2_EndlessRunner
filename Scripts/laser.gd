extends KinematicBody2D

var rotation_rate = 0
var start_position
var dest_position
var vector
var collision
var distance

func _ready(starting_position, vect, starting_distance):
	self.position = starting_position
	distance = starting_distance
	start_position = self.position
	vector = vect
	dest_position = start_position + (distance / 2 * vect.normalized())
	pass

func reappear(new_position, vect, dist):
	self.position = new_position + Vector2(0, rand_range(-10,50))
	start_position = position
	vector = vect
	distance = dist
	dest_position = start_position + (distance / 2 * vector.normalized())
	self.rotation = randf()*90
	rotation_rate += 0.05
	

func _process(delta):
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
	
