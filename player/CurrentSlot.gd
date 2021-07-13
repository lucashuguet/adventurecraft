extends GridContainer

func cursor_change(slot_index):
	for i in range(6):
		get_child(i).set_texture(null)
	
	get_child(slot_index).set_texture(preload("res://gui/selected_slot.png"))
