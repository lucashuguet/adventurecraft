extends GridContainer

var slot = preload("res://gui/selected_slot.png")

var index = 0
var inv

func _on_player_cursor_change(slot_index):
	for i in range(6):
		get_child(i).set_texture(null)
	
	get_child(slot_index).set_texture(slot)
	index = slot_index
	
	update_amount(inv)
	
func update_amount(inventory):
	inv = inventory
	var amount = inventory[index][2]
	if amount != null:
		get_parent().get_node("CenterContainer/Label").text = str(amount)
	else:
		get_parent().get_node("CenterContainer/Label").text = ""
