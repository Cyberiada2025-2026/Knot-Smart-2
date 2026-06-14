extends Control

@export var text_labels: Array[RichTextLabel]
@export var next_button: Button
@export var skip_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PauseController.pause_game()


func _on_skip_button_pressed() -> void:
	end_tutorial()


func _on_next_button_pressed() -> void:
	for i in len(text_labels):
		if i == len(text_labels) - 2:
			next_button.visible = false	
			skip_button.text = "Play"
		if text_labels[i].visible == true and i < len(text_labels):
			text_labels[i].visible = false
			text_labels[i+1].visible = true
			return


func end_tutorial():
	visible = false
	PauseController.unpause_game()
