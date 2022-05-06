extends Node2D

onready var tile = get_node("TileMap")
onready var break_tile = get_node("TileMap/break")

onready var blocks = Variables.blocks # blocks database
export var reach = 5
var hitbox = true


# set mouse mode and setup opening transition
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# loading animation
	add_child(Scene.transition_node.instance())
	var anim = get_node("TransitionScene").get_node("AnimationPlayer") # black curtain animation
	anim.play("backwards")
	yield(anim, "animation_finished")
	get_node("TransitionScene").queue_free()


# shortcuts function
func get_tile(pos) -> Vector2:
	return tile.world_to_map(pos)

func get_cell(pos) -> int:
	return tile.get_cellv(pos)

func set_cell(pos, block) -> void:
	tile.set_cellv(pos, block)


# return if an action can be effectued
func check(pos, action, p_pos) -> bool:
	if action == "break":
		return check_break(pos, p_pos)
	elif action == "place":
		return check_place(pos, p_pos)
	else: return false

func check_place(pos, p_pos) -> bool:
	var pos_bottom = get_tile(p_pos) + Vector2(0, 1)
	var pos_top = get_tile(p_pos) + Vector2(0, -1)

	# print(get_tile(p_pos))

	if pos != pos_top and pos != get_tile(p_pos) and pos != pos_bottom and check_mob():
		if get_cell(pos) == -1:
			if get_cell(pos + Vector2(1, 0)) != -1: # right block
				return true
			elif get_cell(pos + Vector2(-1, 0)) != -1: # left block
				return true
			elif get_cell(pos + Vector2(0, 1)) != -1: # bottom block
				return true
			elif get_cell(pos + Vector2(0, -1)) != -1: # upper block
				return true
			else: return false
		else: return false
	else: return false

func check_break(pos, p_pos) -> bool:
	var pos_bottom = pos + Vector2(0, 1)
	var pos_top = pos + Vector2(0, -1)
	var cell = get_cell(pos)

	if get_tile(p_pos) != pos_top and get_tile(p_pos) != pos and get_tile(p_pos) != pos_bottom:
		if get_cell(pos) != -1:
			if get_cell(pos + Vector2(1, 0)) == -1:
				return not cell == 0 and not cell == 1 and not cell == -1
			elif get_cell(pos + Vector2(-1, 0)) == -1:
				return not cell == 0 and not cell == 1 and not cell == -1
			elif get_cell(pos + Vector2(0, 1)) == -1:
				return not cell == 0 and not cell == 1 and not cell == -1
			elif get_cell(pos + Vector2(0, -1)) == -1:
				return not cell == 0 and not cell == 1 and not cell == -1
			else: return false
		else: return false
	else: return false

func check_mob() -> bool:
	var mobs = get_tree().get_nodes_in_group("mob")
	
	for mob in mobs:
		var sprite = mob.get_node("Sprite")
		if sprite.get_rect().has_point(sprite.get_local_mouse_position()):
			return false
			
	return true


# add the block at given position to player inventory
func add_inventory(pos, who) -> void:
	var inv = who.inventory
	var block = get_cell(pos) # id of the broken block
	var block_name = blocks[block][0] # block name
	var block_id = blocks[block][1] # id of the given block

	if block_name == null: # if the broken block gives nothing ex: leaves
		return

	for i in range(inv.size()): # if block already in player inventory then increment it
		if inv[i][0] == block_name:
			who.inventory[i][2] = inv[i][2] + 1
			return

	var table = [block_name, "block", 1, block_id] # block template

	for i in range(inv.size()): # add template to first empty slot
		if inv[i] == [null, "tool", null, null]:
			who.inventory[i] = table
			break


# break block step by step (8 stages)
func break_block(pos, who) -> void:
	var pos_id = break_tile.get_cellv(pos)

	if tile.get_cellv(pos) == 8:
		pos_id = 8

	if tile.get_cellv(pos) != -1:
		match pos_id:
			-1: break_tile.set_cellv(pos, 0)
			0: break_tile.set_cellv(pos, 1)
			1: break_tile.set_cellv(pos, 2)
			2: break_tile.set_cellv(pos, 3)
			3: break_tile.set_cellv(pos, 4)
			4: break_tile.set_cellv(pos, 5)
			5: break_tile.set_cellv(pos, 6)
			6: break_tile.set_cellv(pos, 7)
			7: break_tile.set_cellv(pos, 8)
			8:
				add_inventory(pos, who)
				tile.set_cellv(pos, -1)
				break_tile.set_cellv(pos, -1)


# player signals
func _on_player_place_block(m_pos, who):
	# m_pos stands for mouse click position
	m_pos = get_tile(m_pos)
	var p_inv = who.inventory # player inventory
	var p_slot = who.current_slot # player current slot
	if get_tile(who.position).distance_to(m_pos) <= reach: # player reach
		if m_pos.x >= 0 and m_pos.x <= tile.max_blocks and m_pos.y >= -64: # world limits
			if check(m_pos, "place", who.position):
				if p_inv[p_slot][1] == "block": # if have a block in hand
					if p_inv[p_slot][2] > -1:
						set_cell(m_pos, p_inv[p_slot][3]) # place block
						# remove the placed block from inventory
						p_inv[p_slot][2] = p_inv[p_slot][2] -1
						# if it was the last item remove it completly
						if p_inv[p_slot][2] == 0:
							who.inventory[p_slot] = [null, "tool", null, null]
							who.cursor_process(p_inv[0][1])

func _on_player_break_block(m_pos, who):
	# m_pos stands for mouse click position
	m_pos = get_tile(m_pos)
	var p_inv = who.inventory # player inventory
	var p_slot = who.current_slot # player current slot
	if get_tile(who.position).distance_to(m_pos) <= reach: # player reach
		if m_pos.x >= 0 and m_pos.x <= tile.max_blocks: # world limits
			# run check and make sure that there is a block to break
			if check(m_pos, "break", who.position) and get_cell(m_pos) != -1:
				if p_inv[p_slot][1] == "tool" or p_inv[p_slot][1] == "block":
					break_block(m_pos, who)
