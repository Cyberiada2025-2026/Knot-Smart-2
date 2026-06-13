class_name BigBoss
extends AnimatableBody3D

@export var movement_animation: AnimationPlayer
@export_file_path(".tscn") var win_scene 

@export var battle_soundtrack: AudioStream

func _on_start_boss_battle() -> void:
	movement_animation.play("move_to_gen")
	var music_player = get_tree().get_first_node_in_group("Player").get_node("MusicPlayer") as MusicPlayer

	music_player.set_soundtrack(battle_soundtrack)
	music_player.disable_areas()

func _on_health_component_health_depleted() -> void:
	print("Big boss killed, you won")

	get_tree().change_scene_to_file(win_scene)
	

