extends GridContainer

func inventory_changed(inv):
	for i in inv.size() -18:
		var slot = get_child(i)
		slot.display_item(inv[i][0])
