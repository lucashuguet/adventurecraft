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

var slots_position = []

var blocks = [
	[bedrock, 0], 
	[forcefield, 1], 
	[dirt, 2], 
	[grass, 3], 
	[cobblestone, 4], 
	[cobblestone, 4], 
	[oak_log, 7], 
	[oak_log, 7], 
	[null, null], # leaves
	[planks, 9], 
	[ladder, 10], 
	[coal_ore, 11], 
	[diamond_ore, 12], 
	[iron_ore, 13], 
	[gold_ore, 14]
]

var tree_model = [
	[
		Vector2(0, -1), 
		Vector2(0, -2)
	], 
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
