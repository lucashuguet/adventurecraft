extends TileMap


export(int) var grid_size = 1
export(int) var max_blocks = 64
export(int) var pos = -32
export(int) var min_height = -34
export(int) var max_height = -30
export(int) var bedrock_height = 0
export(int) var forcefield_height = -71
export(int) var dirt_height = 3
export(int) var max_roughness = 20
export(int) var roughness = 4

export(float) var tree_prop = 0.125
export(float) var iron_prop = 1.0
export(float) var gold_prop = 0.3125
export(float) var diamond_prop = 0.25

var steps = []
var iron = []
var gold = []
var diamond = []
var tree = []


# generate world
func _ready():
	if get_cell(-1, 0) == -1:
		generate()


# regenerate world if R is pressed
func _process(_delta):
	if Input.is_action_pressed("generate"):
		Input.action_release("generate")

		get_parent().add_child(Scene.transition_node.instance())
		var anim = get_parent().get_node("TransitionScene").get_node("AnimationPlayer")
		anim.play("forwards")
		yield(anim, "animation_finished")

		var mobs = get_tree().get_nodes_in_group("mob")
		for i in mobs:
			i.position.y = -2432

		var players = get_tree().get_nodes_in_group("player")
		for i in players:
			i.position.y = -2432

		generate()

		anim.play("backwards")
		yield(anim, "animation_finished")
		get_parent().get_node("TransitionScene").queue_free()


# generate world
func generate():
	clear() # clear all cells
	randomize() # change seed
	steps = []

	for step in max_blocks + 3:
		var action = round(rand_range(0, max_roughness))

		if action > 0 and action < roughness:
			pos -= grid_size # next block up
		elif action > roughness and action < roughness * 2:
			pos += grid_size # next block down

		# block height limits
		if pos < min_height:
			pos = min_height
		elif pos > max_height:
			pos = max_height

		# set grass
		set_cell(step -1, pos, 3)

		# set bedrock
		set_cell(step -1, bedrock_height, 0)

		# add dirt layers the grass
		for i in range(pos+1, pos+dirt_height):
			set_cell(step -1, i, 2)

		# set stone between the bedrock and the dirt
		for i in range(pos+dirt_height, bedrock_height):
			set_cell(step -1, i, 5)

		# set forcefield at begining and end of the world
		if step == 0 or step == max_blocks + 2:
			for i in range(-(pos-1), -(forcefield_height -1)):
				set_cell(step -1, -i, 1)
		else:
			steps.append([step -1, pos])

	ore_generation()


# add ores and trees randomly
func ore_generation():
	
	# clear variables when regenerating the world (press R)
	iron = []
	gold = []
	diamond = []
	tree = []

	if steps != []:
		# Tree
		tree.append(steps[int(round(rand_range(2, 5)))][0]) # first tree x

		for i in max_blocks * tree_prop -1:
			var random = int(round(rand_range(6, 10)))
			var new_tree = tree[tree.size() - 1] + random # next tree x
			if new_tree < max_blocks -1: # world limits
				tree.append(new_tree)

		# generate trees
		for i in tree:
			if i > 1 and i < max_blocks -1:
				# logs
				for b in Variables.tree_model[0]:
					var log_coord = Vector2(i, steps[i][1]) + b
					set_cellv(log_coord, 6)

				# leaves
				for b in Variables.tree_model[1]:
					var leave_coord = Vector2(i, steps[i][1]) + b
					set_cellv(leave_coord, 8)

		# Iron
		for i in max_blocks * iron_prop:
			iron.append(steps[randi() % steps.size()][0])

		for i in iron:
			set_cell(i, int(round(-rand_range(10, 25))), 13)

		# Gold
		for i in max_blocks * gold_prop:
			gold.append(steps[randi() % steps.size()][0])

		for i in gold:
			set_cell(i, int(round(-rand_range(7, 16))), 14)

		# Diamond
		for i in max_blocks * diamond_prop:
			diamond.append(steps[randi() % steps.size()][0])

		for i in diamond:
			set_cell(i, int(round(-rand_range(2, 6))), 12)
