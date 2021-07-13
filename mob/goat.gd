extends KinematicBody2D

export var direction = 1

onready var tile = get_node("/root/world/TileMap")

var weight = 15
var speed = 100
var velocity = Vector2()

func _ready():
	if direction == -1:
		$Sprite.flip_h = true

func get_tile(pos):
	return tile.world_to_map(pos)

func get_cell(pos):
	return tile.get_cell(pos.x, pos.y)

func change_direction():
	direction = direction * -1
	$Sprite.flip_h = not $Sprite.flip_h

func rotate_goat():
	if is_on_floor():
		change_direction()

func check_bottom():
	var block = get_cell(get_tile(position + Vector2(direction * 64, 85)))
	var block_bottom = get_cell(get_tile(position + Vector2(direction * 64, 150)))
	var block_bottom_direction = get_cell(get_tile(position + Vector2(direction * 128, 150)))
	
	if block == -1:
		if block_bottom == -1 and block_bottom_direction == -1:
			rotate_goat()

func check_top():
	var block = get_cell(get_tile(position + Vector2(direction * 60, -1)))
	var block_top = get_cell(get_tile(position + Vector2(direction * 120, -1)))
	
	if block == -1 and block_top == -1:
		velocity.y -= 100
		velocity.x = speed * 2 * direction
	else:
		rotate_goat()

func _process(_delta):
	check_bottom()

func _physics_process(_delta):
	if is_on_wall():
		check_top()

	velocity.y += weight
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
