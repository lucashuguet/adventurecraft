extends Node2D

var overworld = preload("res://dimension/overworld.tscn")

var bedrock = load("res://blocks/bedrock.png")
var forcefield = load("res://blocks/forcefield.png")
var dirt = load("res://blocks/dirt.png")
var grass = load("res://blocks/grass.png")
var cobblestone = load("res://blocks/cobblestone.png")
var stone = load("res://blocks/stone.png")
var oak_log = load("res://blocks/log.png")
var oak_log_hitbox = load("res://blocks/log-hitbox.png")
var leaves = load("res://blocks/leaves.png")
var planks = load("res://blocks/planks.png")
var ladder = load("res://blocks/ladder.png")

var blocks = [[bedrock, 0], [forcefield, 1], [dirt, 2], [grass, 3], [cobblestone, 4], [cobblestone, 4], [oak_log, 7], [oak_log, 7], [null, null], [planks, 9], [ladder, 10]]
onready var slots = [$HUD/inventory/slots/slot1, $HUD/inventory/slots/slot2, $HUD/inventory/slots/slot3, $HUD/inventory/slots/slot4, $HUD/inventory/slots/slot5, $HUD/inventory/slots/slot6, $HUD/inventory/slots/slot7, $HUD/inventory/slots/slot8, $HUD/inventory/slots/slot9]

onready var p_pos = $player.position
onready var p_slot = $player.current_slot
onready var p_inv = $player.inventory

var tile
var hitbox = true
var lock = false

func _ready():
	add_child(overworld.instance())
	tile = get_node("overworld/tile")

func get_tile(pos):
	return tile.world_to_map(pos)

func get_cell(pos):
	return tile.get_cell(pos.x, pos.y)

func set_cell(pos, block):
	tile.set_cell(pos.x, pos.y, block)

func check(pos, action):
	var pos_bottom = pos + Vector2(0, 1)
	var pos_top = pos + Vector2(0, -1)
	var cell = get_cell(pos)

	if action == "break":
		return not cell == 0 and not cell == 1 and not cell == -1
	elif action == "place":
		if get_tile(p_pos) != pos_top and get_tile(p_pos) != pos and get_tile(p_pos) != pos_bottom:
			if get_cell(pos) == -1:
				var around = pos + Vector2(1, 0)
				if get_cell(around) != -1:
					return true
				around = pos + Vector2(-1, 0)
				if get_cell(around) != -1:
					return true
				around = pos + Vector2(0, 1)
				if get_cell(around) != -1:
					return true
				around = pos + Vector2(0, -1)
				if get_cell(around) != -1:
					return true

func check_block(pos):
	var top_cell = get_cell(get_tile(pos + Vector2(0, -75)))
	var middle_cell = get_cell(get_tile(pos))
	var bottom_cell = get_cell(get_tile(pos + Vector2(0, 75)))

	if top_cell == 10 or middle_cell == 10 or bottom_cell == 10: # ladder
		no_gravity()

		if Input.is_action_pressed("up") and !lock:
			$player.position.y -= 3
		elif not($player.is_on_floor()) and !lock:
			$player.position.y += 3
	else:
		var check_cell = get_cell(get_tile(pos + Vector2(0, 100)))

		if check_cell == 10:
			if Input.is_action_pressed("up"):
				lock = true
				no_gravity()
			elif Input.is_action_just_released("up"):
				gravity()
		else:
			gravity()

func gravity():
	lock = false
	$player.weight = 15
	$player.gravity = true
	
func no_gravity():
	$player.velocity.y = 0
	$player.weight = 3
	$player.gravity = false

func add_inventory(pos, inv):
	var block = get_cell(pos)
	var block_name = blocks[block][0]
	var block_id = blocks[block][1]

	if block_name == null:
		return

	var index = 0
	for i in inv:
		if i[0] == block_name:
			inv[index][2] = inv[index][2] + 1
			return
		index = index + 1

	if inv.size() <= 9:
		var table = [block_name, "block", 1, block_id]
		inv.append(table)

	$player.inventory = inv

func display_inventory(inv):
	for i in range(0, 9):
		if i != 0 and i < inv.size():
			slots[i - 1].set_texture(inv[i][0])
		else:
			slots[i - 1].texture = null

func show_coordinate(pos):
	var coordinate = tile.world_to_map(pos) + Vector2(0, 1)
	$HUD/position.text = "Position: (" + str(coordinate.x) + ";" + str(-coordinate.y) + ")"

	if coordinate.y > 0:
		if get_tree().change_scene("res://world/world.tscn") != OK:
			print ("An unexpected error occured when trying to switch scene")

func refresh_var():
	$player.current_slot = p_slot
	$player.inventory = p_inv

func which_block_behind_goat(pos, who):
	var block_pos = get_tile(pos) + Vector2(who.direction, 2)
	who.rotate(get_cell(block_pos))

func _process(_delta):
	p_pos = $player.position
	p_slot = $player.current_slot
	p_inv = $player.inventory

	if Input.is_action_pressed("left_click"):
		var m_pos = get_tile(get_global_mouse_position())
		if m_pos.x >= 0 and m_pos.x <= 64 and check(m_pos, "break") and get_cell(m_pos) != -1:
			if p_inv[p_slot][1] == "tool" or p_inv[p_slot][1] == "block":
				add_inventory(m_pos, p_inv)
				set_cell(m_pos, -1)

	if Input.is_action_pressed("right_click"):
		var m_pos = get_tile(get_global_mouse_position())
		if m_pos.x >= 0 and m_pos.x <= 64 and m_pos.y >= -64 and check(m_pos, "place"):
			if p_inv[p_slot][1] == "block":
				if p_inv[p_slot][2] > -1:
					set_cell(m_pos, p_inv[p_slot][3])
					p_inv[p_slot][2] = p_inv[p_slot][2] -1
					if p_inv[p_slot][2] == 0:
						p_inv.remove(p_slot)
						p_slot = 0
						refresh_var()
						$player.inventory_process(p_inv[0][1])

	refresh_var()
	display_inventory(p_inv)
	show_coordinate(p_pos)

func _physics_process(_delta):
	check_block(p_pos)
