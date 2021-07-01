extends CanvasLayer

func _process(_delta):
	if Input.is_action_pressed("inventory"):
		$CenterContainer.show()
	if Input.is_action_just_released("inventory"):
		$CenterContainer.hide()
