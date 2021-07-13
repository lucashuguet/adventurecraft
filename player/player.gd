extends KinematicBody2D

signal grounded_updated(is_grounded)
signal place_block(pos, who)
signal break_block(pos, who)
signal inventory_change(inv)
signal cursor_change(slot_index)

var crosshair = Variables.crosshair
var sword = Variables.sword

onready var tile = get_node("/root/world/TileMap")

export var speed = 400
export var weight = 15
export var jump = -1000
export var gravity = true
 
var is_grounded
var current_slot = 0
var velocity = Vector2()
var lock = false

var inventory = [[sword, "weapon", 1, 10], [Variables.cobblestone, "block", 64, 4], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null], [null, "tool", null, null]]

func _ready():
	$AnimatedSprite.play()
	emit_signal("inventory_change", inventory)
	cursor_process(inventory[current_slot][1])

func get_tile(pos):
	return tile.world_to_map(pos)

func get_cell(pos):
	return tile.get_cell(pos.x, pos.y)

func show_coordinate():
	var coordinate = get_tile(position) + Vector2(0, 1)
	$Camera2D/HUD/position.text = "Position: (" + str(coordinate.x) + ";" + str(-coordinate.y) + ")"

func cursor_process(type):
	if type == "block":
		var cursor = ImageTexture.new()
		var block: Image = inventory[current_slot][0].get_data()
		block.resize(32, 32)
		cursor.create_from_image(block)                  
		Input.set_custom_mouse_cursor(cursor)
	else:
		if not(inventory[current_slot][0]) == null:
			Input.set_custom_mouse_cursor(inventory[current_slot][0])
		else:
			Input.set_custom_mouse_cursor(crosshair)
	emit_signal("cursor_change", current_slot)
	
func check_block(pos):
	var top_cell = get_cell(get_tile(pos + Vector2(0, -75)))
	var middle_cell = get_cell(get_tile(pos))
	var bottom_cell = get_cell(get_tile(pos + Vector2(0, 75)))

	if top_cell == 10 or middle_cell == 10 or bottom_cell == 10: # ladder
		no_gravity()

		if Input.is_action_pressed("up") and !lock:
			position.y -= 3
		elif bottom_cell == 10 and !lock:
			position.y += 3
	else:
		var check_cell = get_cell(get_tile(pos + Vector2(0, 100)))

		if check_cell == 10:
			if Input.is_action_pressed("up"):
				lock = true
				no_gravity()
			elif Input.is_action_just_released("up"):
				gravity_on()
		else:
			gravity_on()

func gravity_on():
	lock = false
	weight = 15
	gravity = true
	
func no_gravity():
	velocity.y = 0
	weight = 3
	gravity = false

func _process(_delta):
	if Input.is_action_just_released("scroll_up"):
		if current_slot == 5:
			current_slot = 0
		else:
			current_slot = current_slot + 1
		cursor_process(inventory[current_slot][1])
		
	if Input.is_action_just_released("scroll_down"):
		if current_slot == 0:
			current_slot = 5
		else:
			current_slot = current_slot - 1
		cursor_process(inventory[current_slot][1])
		
	if $Camera2D/HUD.show_inv == false:
		if Input.is_action_pressed("right_click"):
			emit_signal("place_block", get_global_mouse_position(), get_node("."))
			emit_signal("inventory_change", inventory)
			
		if Input.is_action_pressed("left_click"):
			emit_signal("break_block", get_global_mouse_position(), get_node("."))
			emit_signal("inventory_change", inventory)
			cursor_process(inventory[current_slot][1])
		
	show_coordinate()
	
func _physics_process(_delta):
	if Input.is_action_pressed("right"):
		velocity.x = speed
	if Input.is_action_pressed("left"):
		velocity.x = -speed

	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0

	if gravity:
		velocity.y = velocity.y + weight

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump

	velocity = move_and_slide(velocity, Vector2.UP)

	velocity.x = lerp(velocity.x, 0, 0.2)

	var was_grounded = is_grounded
	is_grounded = is_on_floor()

	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)
		
	check_block(position)
	
func inv_changed(inv):
	inventory = inv
	cursor_process(inventory[current_slot][1])


func inventory_changed(inv):
	pass # Replace with function body.
