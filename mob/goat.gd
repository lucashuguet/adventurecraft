extends KinematicBody2D

export var direction = 1

onready var tile = get_node("/root/world/TileMap")

var weight = 15
var speed = 100
var velocity = Vector2()
var flip_lerp = 0.1
var top_block = false

func _ready():
	paper_flip(direction)
	rotate_raycast(direction)
	
func rotate_raycast(dir):
	$RayTop.position.x = $RayTop.position.x * dir

func get_tile(pos):
	return tile.world_to_map(pos)

func get_cell(pos):
	return tile.get_cell(pos.x, pos.y)

func paper_flip(dir):
	flip_lerp = flip_lerp * dir

func change_direction():
	direction = direction * -1
	paper_flip(-1)
		
func rotate_goat():
	if is_on_floor():
		change_direction()
		rotate_raycast(-1)

func jump():
	velocity.y -= 50

func _process(_delta):
	$Sprite.scale.x = lerp($Sprite.scale.x, flip_lerp, 0.1)

func _physics_process(_delta):
	if is_on_wall():
		if not top_block: jump()
		else: rotate_goat()

	velocity.y += weight
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Timer_timeout():
	top_block = $RayTop.is_colliding()
