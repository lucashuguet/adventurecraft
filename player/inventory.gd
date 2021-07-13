extends TextureRect

signal inv_changed(inv)
signal items_changed(indexes)

var items = []

func set_item(item_index, item):
	var previousItem = items[item_index]
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	emit_signal("inv_changed", items)
	return previousItem
	
func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])
	emit_signal("inv_changed", items)
	
func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = [null, "tool", null, null]
	emit_signal("items_changed", [item_index])
	emit_signal("inv_changed", items)
	return previousItem

func inventory_change(inv):
	items = inv
	$CenterContainer/InventoryDisplay.update_inventory_display()
	$CenterContainer2/HotbarDisplay.update_inventory_display()
