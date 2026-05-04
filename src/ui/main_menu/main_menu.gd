extends Control


func _on_play_button_pressed():
	SceneManager.goto_scene("res://scenes/debug/beta_level/beta_level.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
