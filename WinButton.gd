extends TextureButton

@export var sceneName: String = "Level1"

func _on_pressed():
	get_tree().change_scene_to_file("res://scenes/" + sceneName + ".tscn")
