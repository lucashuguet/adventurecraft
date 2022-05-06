extends CanvasLayer

var show_inv = false
var moving_item = false

onready var inventory = get_node("Center/InventoryContainer")
onready var hotbar = get_node("CenterBottom/Hotbar")


# hide inventory
func _ready():
	inventory.hide()


# show inventory and hide hotbar if E is pressed
func _process(_delta):
	if Input.is_action_pressed("inventory"):
		Input.action_release("inventory")
		if show_inv == false:
			inventory.show()
			hotbar.hide()
			show_inv = true
		else:
			inventory.hide()
			hotbar.show()
			show_inv = false
