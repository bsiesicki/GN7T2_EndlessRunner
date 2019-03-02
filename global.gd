extends Node

var music = true

var settings = "user://settings.txt"

func _ready():
	load_settings()
	pass

func load_settings():
    var f = File.new()
    if f.file_exists(settings):
        f.open(settings, File.READ)
        var content = f.get_as_text()
        music = bool(content)
        f.close()
		
func save_settings():
    var f = File.new()
    f.open(settings, File.WRITE)
    f.store_string(str(music))
    f.close()