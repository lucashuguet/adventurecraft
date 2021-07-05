extends CanvasLayer

func _process(_delta):
	if Input.is_action_pressed("inventory"):
		$inventory.show()
	if Input.is_action_just_released("inventory"):
		$inventory.hide()
