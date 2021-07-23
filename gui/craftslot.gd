extends CenterContainer

signal new_item(item)

onready var inventory = get_parent().get_parent()
onready var itemTextureRect = $ItemTextureRect

var current_item = [null, "tool", null, null]

func display_item(item):
	itemTextureRect.texture = item[0]
	current_item = item
		
func get_drag_data(_position):
	var item = current_item
	if item[0] == null:
		return
	if item is Array:
		var data = {}
		data.item = current_item
		data.item_index = "craft"
		var dragPreview = TextureRect.new()
		dragPreview.texture = item[0]
		current_item = [null, "tool", null, null]
		display_item(current_item)
		set_drag_preview(dragPreview)
		emit_signal("new_item", current_item)
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	if not data.item[1] == "block":
		inventory.set_item(data.item_index, data.item)
		return
#	print(Variables.blocks[data.item[3]][2])
	if not data.item_index is String:
		inventory.remove_item(data.item_index)
	inventory.set_item(data.item_index, current_item)
	display_item(data.item)
	current_item = data.item
	emit_signal("new_item", current_item)
