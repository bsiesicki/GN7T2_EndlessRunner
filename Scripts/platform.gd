extends StaticBody2D

# pozycja lasera na osi X
var platform_position_x = 80
# pozycja lasera na osi Y
var platform_position_y = 50


#kąt startowy do obrotu
func reappear(camera, x):
	if self.position < camera.position - Vector2(700,0):
		self.position = camera.position + Vector2(200+x,rand_range(10,30))
		print(self.position.y)

