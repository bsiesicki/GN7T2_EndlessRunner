extends CanvasLayer



func _on_TextureButton_pressed():
	get_tree().paused = true
	$pausePopup.show()

func _on_resumeButton_pressed():
	$pausePopup.hide()
	get_tree().paused = false


func _on_restartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

