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
onready var slots = [$HUD/CenterContainer/inventory/slot1, $HUD/CenterContainer/inventory/slot2, $HUD/CenterContainer/inventory/slot3, $HUD/CenterContainer/inventory/slot4, $HUD/CenterContainer/inventory/slot5, $HUD/CenterContainer/inventory/slot6, $HUD/CenterContainer/inventory/slot7, $HUD/CenterContainer/inventory/slot8, $HUD/CenterContainer/inventory/slot9]

var tile
var hitbox = true
var lock = false

func _ready():
	add_child(overworld.instance())
	tile = get_node("overworld/tile")

func get_tile(mouse_pos):
	var cell_pos = tile.world_to_map(mouse_pos)
	return cell_pos

func check(pos, action):
	var player_pos = $player.position
	var tile_pos = tile.world_to_map(player_pos)
	var tile_pos_bottom = tile_pos + Vector2(0, 1)
	var tile_pos_top = tile_pos + Vector2(0, -1)
	var current_cell = tile.get_cell(pos.x, pos.y)
	
	if (pos != tile_pos and pos != tile_pos_bottom and pos != tile_pos_top) or action == "break":
		if current_cell == 0 or current_cell == 1: # bedrock or forcefield
			return false
		else:
			return true
	else:
		return false

func check_around(pos, action):
	if tile.get_cell(pos.x, pos.y) == -1 and check(pos, action):
		var around = pos + Vector2(1, 0)
		if tile.get_cell(around.x, around.y) != -1:
			return true
		around = pos + Vector2(-1, 0)
		if tile.get_cell(around.x, around.y) != -1:
			return true
		around = pos + Vector2(0, 1)
		if tile.get_cell(around.x, around.y) != -1:
			return true
		around = pos + Vector2(0, -1)
		if tile.get_cell(around.x, around.y) != -1:
			return true

func add_inventory(pos):
	var block = tile.get_cell(pos.x, pos.y)
	var block_name = blocks[block][0]
	var block_id = blocks[block][1]
	
	if block_name == null:
		return
	
	var index = 0
	for i in $player.inventory:
		if i[0] == block_name:
			$player.inventory[index][2] = $player.inventory[index][2] + 1
			return
		index = index + 1
		
	if $player.inventory.size() <= 9:
		var table = [block_name, "block", 1, block_id]
		$player.inventory.append(table)

func _process(_delta):
	if Input.is_action_pressed("left_click"):
		var clicked = get_tile(get_global_mouse_position())
		if clicked.x >= 0 and check(clicked, "break") and tile.get_cell(clicked.x, clicked.y) != -1:
			add_inventory(clicked)
			tile.set_cell(clicked.x, clicked.y, -1)
			
	if Input.is_action_pressed("right_click"):
		var clicked = get_tile(get_global_mouse_position())
		if clicked.x >= 0 and check_around(clicked, "place"):
			if $player.inventory[$player.current_slot][1] == "block":
				if $player.inventory[$player.current_slot][2] > -1:
					tile.set_cell(clicked.x, clicked.y, $player.inventory[$player.current_slot][3])
					$player.inventory[$player.current_slot][2] = $player.inventory[$player.current_slot][2] -1
					if $player.inventory[$player.current_slot][2] == 0:
						$player.inventory.remove($player.current_slot)
						$player.current_slot = 0
						$player.inventory_process($player.inventory[0][1])
	
	var player_pos = $player.position
	var tile_pos = tile.world_to_map(player_pos)
	tile_pos = tile_pos + Vector2(0, 1)
	$HUD/position.text = "Position: (" + str(tile_pos.x) + ";" + str(-tile_pos.y) + ")"
	
	if tile_pos.y > 64:
		$player.position = Vector2(280, 280)
		
	for i in range(0, 9):
		if i != 0 and i < $player.inventory.size():
			slots[i - 1].set_texture($player.inventory[i][0])
		else:
			slots[i - 1].texture = null
		
func _physics_process(_delta):
	var player_pos = $player.position + Vector2(0, 80)
	var top_pos = player_pos - Vector2(0, 160)
	var player_tile = tile.world_to_map(player_pos)
	var top_tile = tile.world_to_map(top_pos)
	var top_cell = tile.get_cell(top_tile.x, top_tile.y)
	var player_cell = tile.get_cell(player_tile.x, player_tile.y)


	if player_cell == 10 or top_cell == 10:
		
		$player.velocity.y = 0
		$player.weight = 3
		$player.gravity = false
		
		if Input.is_action_pressed("up") and !lock:
			$player.position.y -= 3
		elif not($player.is_on_floor()) and !lock:
			$player.position.y += 3
	else:
		var check_tile = player_tile + Vector2(0, 1)
		var check_cell = tile.get_cell(check_tile.x, check_tile.y)
		
		if check_cell == 10:
			if Input.is_action_pressed("up"):
				lock = true
		else:
			lock = false
			$player.weight = 15
			$player.gravity = true
