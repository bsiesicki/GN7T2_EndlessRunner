extends Control


onready var global


func _ready():
	global = get_node("/root/global")
	if (global.music == true):
		get_node("CenterContainer/VBoxContainer/musicButton").text = "MUSIC ON"
	elif (global.music == false):
		get_node("CenterContainer/VBoxContainer/musicButton").text = "MUSIC OFF"
	


func _on_backButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	

func _on_musicButton_pressed():
	if ($CenterContainer/VBoxContainer/musicButton.text == "MUSIC ON"):
		$CenterContainer/VBoxContainer/musicButton.text = "MUSIC OFF"
		global.music = false
		global.save_settings()
	else:
		$CenterContainer/VBoxContainer/musicButton.text = "MUSIC ON"
		global.music = true
		global.save_settings()


func _on_creditsButton_pressed():
	get_tree().change_scene("res://Scenes/Credits.tscn")
	
