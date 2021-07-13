extends CenterContainer

onready var inventory = get_node("InventoryContainer")

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	inventory.set_item(data.item_index, data.item)
