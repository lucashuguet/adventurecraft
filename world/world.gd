extends Node2D

onready var tile = get_node("TileMap")

var blocks = Variables.blocks
var hitbox = true

func get_tile(pos):
	return tile.world_to_map(pos)

func get_cell(pos):
	return tile.get_cell(pos.x, pos.y)

func set_cell(pos, block):
	tile.set_cell(pos.x, pos.y, block)

func check(pos, action, p_pos):
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

func add_inventory(pos, who):
	var inv = who.inventory
	var block = get_cell(pos)
	var block_name = blocks[block][0]
	var block_id = blocks[block][1]

	if block_name == null:
		return

	var index = 0
	for i in inv:
		if i[0] == block_name:
			who.inventory[index][2] = inv[index][2] + 1
			return
		index += 1

	if inv.size() <= 24:
		var table = [block_name, "block", 1, block_id]
		index = 0
		for i in inv:
			if i == [null, "tool", null, null]:
				who.inventory[index] = table
				return
			index += 1

func _on_player_place_block(m_pos, who):
	m_pos = get_tile(m_pos)
	var p_inv = who.inventory
	var p_slot = who.current_slot
	if m_pos.x >= 0 and m_pos.x <= 64 and m_pos.y >= -64 and check(m_pos, "place", who.position):
		if p_inv[p_slot][1] == "block":
			if p_inv[p_slot][2] > -1:
				set_cell(m_pos, p_inv[p_slot][3])
				p_inv[p_slot][2] = p_inv[p_slot][2] -1
				if p_inv[p_slot][2] == 0:
					who.inventory[p_slot] = [null, "tool", null, null]
					who.cursor_process(p_inv[0][1])

func _on_player_break_block(m_pos, who):
	m_pos = get_tile(m_pos)
	var p_inv = who.inventory
	var p_slot = who.current_slot
	if m_pos.x >= 0 and m_pos.x <= 64 and check(m_pos, "break", who.position) and get_cell(m_pos) != -1:
		if p_inv[p_slot][1] == "tool" or p_inv[p_slot][1] == "block":
			add_inventory(m_pos, who)
			set_cell(m_pos, -1)
