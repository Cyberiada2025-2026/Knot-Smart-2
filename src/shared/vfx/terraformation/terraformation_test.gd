extends Node

@export var vfx: TerraformationVFX

func _ready() -> void:
	vfx.start_growing()
