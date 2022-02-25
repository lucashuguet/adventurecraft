extends Node

var crosshair = preload("res://gui/crosshair.png")
var sword = preload("res://items/diamond_sword.png")
var bedrock = preload("res://blocks/bedrock.png")
var forcefield = preload("res://blocks/forcefield.png")
var dirt = preload("res://blocks/dirt.png")
var grass = preload("res://blocks/grass.png")
var cobblestone = preload("res://blocks/cobblestone.png")
var stone = preload("res://blocks/stone.png")
var oak_log = preload("res://blocks/log.png")
var oak_log_hitbox = preload("res://blocks/log-hitbox.png")
var leaves = preload("res://blocks/leaves.png")
var planks = preload("res://blocks/planks.png")
var ladder = preload("res://blocks/ladder.png")
var coal_ore = preload("res://blocks/coal_ore.png")
var diamond_ore = preload("res://blocks/diamond_ore.png")
var iron_ore = preload("res://blocks/iron_ore.png")
var gold_ore = preload("res://blocks/gold_ore.png")


# array: [ texture, tilemap_index, name, break_speed ]
var blocks = [
	[bedrock, 0, "bedrock", null], 
	[forcefield, 1, "forcefield", null], 
	[dirt, 2, "dirt", 0.05],
	[grass, 3, "grass", 0.05],
	[cobblestone, 4, "cobblestone", 0.4], 
	[cobblestone, 4, "stone", 0],
	[oak_log, 7, "log", 0.2], 
	[oak_log, 7, "log", 0.2],
	[null, null, "leaves", 0], # leaves
	[planks, 9, "planks", 0.1],
	[ladder, 10, "ladder", 0.1],
	[coal_ore, 11, "coal_ore", 0.5],
	[diamond_ore, 12, "diamond_ore", 0.5],
	[iron_ore, 13, "iron_ore", 0.5],
	[gold_ore, 14, "gold_ore", 0.5]
]


# array of vectors to build a tree
var tree_model = [
	# log
	[
		Vector2(0, -1), 
		Vector2(0, -2)
	],
	# leaves
	[
		Vector2(-2, -3),
		Vector2(-1, -3),
		Vector2(0, -3),
		Vector2(1, -3),
		Vector2(2, -3),
		Vector2(-2, -4),
		Vector2(-1, -4),
		Vector2(0, -4),
		Vector2(1, -4),
		Vector2(2, -4),
		Vector2(-1, -5),
		Vector2(0, -5),
		Vector2(1, -5),
		Vector2(0, -6),
	]
]


# return an array of the output item for the recipe
func craft(item: Array) -> Array:
	# array: [icon, name, amount, tilemap_id]
	if item[0] == null:
		return [null, "tool", null, null]
	else:
		var item_name = blocks[item[3]][2]
		var amount = item[2]
		match item_name:
			"log":
				return [planks, "block", amount*4, 9]
			"cobblestone":
				return [diamond_ore, "block", amount*10, 12]
			_:
				return item
