extends Control


onready var global


func _ready():
	global = get_node("/root/global")
	global.load_settings()
	if (global.music == true):
		get_node("VBoxContainer/musicButton").text = "MUSIC ON"
	else:
		get_node("VBoxContainer/musicButton").text = "MUSIC OFF"
	


func _on_backButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	

func _on_musicButton_pressed():
	if ($VBoxContainer/musicButton.text == "MUSIC ON"):
		$VBoxContainer/musicButton.text = "MUSIC OFF"
		global.music = false
		global.save_settings()
	else:
		$VBoxContainer/musicButton.text = "MUSIC ON"
		global.music = true
		global.save_settings()


func _on_creditsButton_pressed():
	get_tree().change_scene("res://Scenes/Credits.tscn")
	
