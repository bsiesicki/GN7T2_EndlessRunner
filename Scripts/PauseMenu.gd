extends CanvasLayer

var position

func _on_TextureButton_pressed():
	get_tree().paused = true
	position = get_parent().get_node("AudioStreamPlayer2D").get_playback_position()
	get_parent().get_node("AudioStreamPlayer2D").stop()
	$pausePopup.show()

func _on_resumeButton_pressed():
	$pausePopup.hide()
	if (get_node("/root/global").music == true):
		get_parent().get_node("AudioStreamPlayer2D").play(position)
	get_tree().paused = false


func _on_restartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

