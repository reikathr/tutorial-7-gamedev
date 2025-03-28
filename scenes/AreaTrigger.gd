extends Area3D

@export var sceneName := "Level1"
@export var target_node_path: NodePath

func _on_body_entered(body):
	if body.get_name() == "Player":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if get_tree().current_scene.name == sceneName:
			var target_node = get_node(target_node_path)
			if target_node:
				var teleport_offset = Vector3(2, 0, 0)
				body.teleport_to(target_node.global_transform.origin + teleport_offset)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			get_tree().call_deferred("change_scene_to_file", "res://scenes/" + sceneName + ".tscn")
