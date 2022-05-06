extends CenterContainer

onready var craftslot = get_parent().get_node("InventorySlotDisplay")
var current_item = [null, "tool", null, null]

func display_item(item):
	if item[0] is StreamTexture:
		$ItemTextureRect.texture = item[0]
	else:
		$ItemTextureRect.texture = null
	current_item = item

func new_item(item):
	display_item(Variables.craft(item))
	get_parent().get_node("InventorySlotDisplay").display_item([null, "tool", null, null])
	
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
		return data
