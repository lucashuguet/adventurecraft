extends CenterContainer

onready var inventory = get_node("/root/world/player/Camera2D/HUD/center/InventoryContainer")

onready var itemTextureRect = $ItemTextureRect

func display_item(item):
	if item is StreamTexture:
		itemTextureRect.texture = item
	else:
		itemTextureRect.texture = null

func get_drag_data(_position):
	var item_index
	if get_parent().name == "HotbarDisplay":
		item_index = get_index()
	elif get_parent().name == "InventoryDisplay":
		item_index = get_index() + 6
	var item = inventory.remove_item(item_index)
	if item is Array:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = TextureRect.new()
		dragPreview.texture = item[0]
		set_drag_preview(dragPreview)
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var my_item_index
	if get_parent().name == "HotbarDisplay":
		my_item_index = get_index()
	elif get_parent().name == "InventoryDisplay":
		my_item_index = get_index() + 6
	inventory.swap_items(my_item_index, data.item_index)
	inventory.set_item(my_item_index, data.item)
