extends TileMap


export(int) var grid_size
export(int) var max_blocks
export(int) var pos
export(int) var min_height
export(int) var max_height
export(int) var bedrock_height
export(int) var forcefield_height
export(int) var dirt_height
export(int) var max_roughness
export(int) var roughness

var steps = []
var iron = []
var gold = []
var diamond = []
var tree = []

var pause = false

func _ready():
	if get_cell(-1, 0) == -1:
		generate()
	
func _process(_delta):
	if not pause:
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

func generate():
	clear()
	randomize()
	steps = []
	
	for step in max_blocks + 3:
		var action = round(rand_range(0, max_roughness))
		
		if action > 0 and action < roughness:
			pos -= grid_size
		elif action > roughness and action < roughness * 2:
			pos += grid_size
			
		if pos < min_height:
			pos = min_height
		elif pos > max_height:
			pos = max_height
			
		
		set_cell(step -1, pos, 3)
		set_cell(step -1, bedrock_height, 0)
		
		for i in range(pos+1, pos+dirt_height):
			set_cell(step -1, i, 2)
			
		for i in range(pos+dirt_height, bedrock_height):
			set_cell(step -1, i, 5)
			
		if step -1 == -1 or step -1 == max_blocks + 1:
			for i in range(-(pos-1), -(forcefield_height -1)):
				set_cell(step -1, -i, 1)
		else:
			steps.append([step -1, pos])

	ore_generation()

func ore_generation():
	iron = []
	gold = []
	diamond = []
	tree = []
	
	if steps != []:
		# Tree
		
		tree.append(steps[int(round(rand_range(2, 5)))][0])
		
		for i in 20:
			var random = int(round(rand_range(5, 10)))
			var new_tree = tree[tree.size() - 1] + random
			if new_tree < 63:
				tree.append(new_tree)
		
		for i in tree:
			if i > 1 and i < 63:
				for b in Variables.tree_model[0]:
					var log_coord = Vector2(i, steps[i][1]) + b
					set_cellv(log_coord, 6)
					
				for b in Variables.tree_model[1]:
					var log_coord = Vector2(i, steps[i][1]) + b
					set_cellv(log_coord, 8)
			
		# Iron
		for i in 64:
			iron.append(steps[randi() % steps.size()][0])
		
		for i in iron:
			set_cell(i, int(round(-rand_range(10, 25))), 13)
	
		# Gold
		for i in 20:
			gold.append(steps[randi() % steps.size()][0])
	
		for i in gold:
			set_cell(i, int(round(-rand_range(7, 16))), 14)
		
		# Diamond
		for i in 16:
			diamond.append(steps[randi() % steps.size()][0])
	
		for i in diamond:
			set_cell(i, int(round(-rand_range(2, 6))), 12)