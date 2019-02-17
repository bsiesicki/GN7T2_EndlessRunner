extends Control


func _on_backButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	

func _on_musicButton_pressed():
	if ($CenterContainer/VBoxContainer/musicButton.text == "MUSIC ON"):
		$CenterContainer/VBoxContainer/musicButton.text = "MUSIC OFF"
	else:
		$CenterContainer/VBoxContainer/musicButton.text = "MUSIC ON"



func _on_creditsButton_pressed():
	get_tree().change_scene("res://Scenes/Credits.tscn")
	
