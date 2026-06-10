class_name BigBoss
extends AnimatableBody3D

@export var movement_animation: AnimationPlayer




func _on_start_boss_battle(_node) -> void:
	movement_animation.play("move_to_gen")

