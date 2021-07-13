extends GridContainer

onready var inventory = get_node("/root/world/player/Camera2D/HUD/center/InventoryContainer")

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")
	
func update_inventory_display():
	for item_index in inventory.items.size():
		if item_index > 5:
			update_inventory_slot_display(item_index)
	
func update_inventory_slot_display(item_index):
	if item_index > 5:
		var inventorySlotDisplay = get_child(item_index -6)
		var item = inventory.items[item_index][0]
		inventorySlotDisplay.display_item(item)

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)
