extends TextureRect

signal inv_changed(inv)
signal items_changed(indexes)

var items = []

func set_item(item_index, item):
	if item_index is String:
		$CrafingDisplay/InventorySlotDisplay.display_item(item)
	else:
		var previousItem = items[item_index]
		items[item_index] = item
		emit_signal("items_changed", [item_index])
		emit_signal("inv_changed", items)
		return previousItem

func swap_items(item_index, target_item_index, data):
	var item = items[item_index]
	if target_item_index is String:
		$CrafingDisplay/InventorySlotDisplay.display_item(item)
		items[item_index] = data.item
		emit_signal("items_changed", [item_index])
	else:
		var targetItem = items[target_item_index]
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

func _on_player_inventory_changed(inv):
	items = inv
	$CenterContainer/InventoryDisplay.update_inventory_display()
	$CenterContainer2/HotbarDisplay.update_inventory_display()
