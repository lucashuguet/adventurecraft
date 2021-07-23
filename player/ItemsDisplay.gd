extends GridContainer

func update_inv(inv):
	get_parent().get_node("CurrentSlot").update_amount(inv)
	
	for i in inv.size() -18:
		var slot = get_child(i)
		slot.display_item(inv[i][0])

func _on_player_inventory_changed(inv):
	update_inv(inv)

func _on_InventoryContainer_inv_changed(inv):
	update_inv(inv)
