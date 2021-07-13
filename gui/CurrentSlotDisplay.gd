extends CenterContainer

onready var itemTextureRect = $ItemTextureRect

func set_texture(item):
	if item is StreamTexture:
		itemTextureRect.texture = item
	else:
		itemTextureRect.texture = null
