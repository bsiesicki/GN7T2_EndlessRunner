extends Node

var music = true

var settings = "user://settings.data"

func _ready():
	load_settings()

func load_settings():
    var f = File.new()
    if f.file_exists(settings):
        f.open(settings, File.READ)
        music = f.get_var()
        f.close()
		
func save_settings():
    var f = File.new()
    f.open(settings, File.WRITE)
    f.store_var(music)
    f.close()