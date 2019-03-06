extends StaticBody2D

# pozycja lasera na osi X
var platform_position_x = 80
# pozycja lasera na osi Y
var platform_position_y = 50

func _ready(starting_position, vect, starting_distance):
	self.position = starting_position
	pass

#kąt startowy do obrotu
func reappear(new_position, vect, dist, count):
	self.position = new_position + Vector2(0,rand_range(10,30))

