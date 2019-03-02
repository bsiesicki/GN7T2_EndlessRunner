extends Control



func _on_playButton_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_settingsButton_pressed():
	get_tree().change_scene("res://Scenes/Settings.tscn")


func _on_quitButton_pressed():
	get_tree().quit()
