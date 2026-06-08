extends Camera3D

@export var origin: Camera3D

func _process(_delta: float) -> void:
	global_position = origin.global_position
	global_rotation = origin.global_rotation
	fov = origin.fov
