extends KinematicBody2D

export var direction = 1

onready var tile = get_node("/root/world/TileMap")

export var weight = 15
export var speed = 100
export var jump_height = 60

var velocity = Vector2()
var flip_lerp = 0.1
var top_block = false


# setup goat and raycast direction
func _ready():
	paper_flip(direction)
	rotate_raycast(direction)


# usefull tilemap functions
func get_tile(pos):
	return tile.world_to_map(pos)

func get_cell(pos):
	return tile.get_cellv(pos)


# set raycast infront of the goat
func rotate_raycast(dir):
	$RayTop.position.x = $RayTop.position.x * dir


# rotate with a paper mario look
func paper_flip(dir):
	flip_lerp = flip_lerp * dir


# change direction and change paper_flip function
func change_direction():
	direction = direction * -1
	paper_flip(-1)


# call change_direction and rotate_raycast
func rotate_goat():
	if is_on_floor():
		change_direction()
		rotate_raycast(-1)


# jump
func jump():
	velocity.y -= jump_height


# check raycast and process paper like rotation
func _process(_delta):
	top_block = $RayTop.is_colliding()
	$Sprite.scale.x = lerp($Sprite.scale.x, flip_lerp, 0.1)


# physics
func _physics_process(_delta):
	if is_on_wall():
		if not top_block: jump()
		else: rotate_goat()

	velocity.y += weight
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
