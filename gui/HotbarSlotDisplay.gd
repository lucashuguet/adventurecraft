extends CenterContainer

onready var itemTextureRect = $ItemTextureRect

func display_item(item):
	if item is StreamTexture:
		itemTextureRect.texture = item
	else:
		itemTextureRect.texture = null
