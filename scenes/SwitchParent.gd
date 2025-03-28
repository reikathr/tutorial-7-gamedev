extends MeshInstance3D

@export var light : NodePath

@onready var switchBody: Node3D = $StaticBody3D

func _ready():
	switchBody.light = light
