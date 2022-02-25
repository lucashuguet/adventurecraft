extends Control

var is_paused = false


# pause game when escape if pressed
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		set_is_paused(!is_paused)


# pause game and show pause GUI
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused 


# resume game
func _on_ResumeBtn_pressed():
	set_is_paused(false)


# quit game
func _on_QuitBtn_pressed():
	get_tree().quit()
