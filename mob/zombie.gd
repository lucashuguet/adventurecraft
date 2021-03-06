extends KinematicBody2D

export var direction = 1

onready var tile = get_node("/root/world/TileMap")

var weight = 15
var speed = 100
var velocity = Vector2()
var flip_lerp = 0.25
var top_block = false
var wait_timer = false
var health = 20


# setup zombie and raycast direction
func _ready():
	paper_flip(direction)
	rotate_raycast(direction)


# usefull tilemap functions
func get_tile(pos):
	return tile.world_to_map(pos)

func get_cell(pos):
	return tile.get_cell(pos.x, pos.y)


# set raycast infront of the zombie
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
func rotate_zombie():
	if is_on_floor():
		change_direction()
		rotate_raycast(-1)


# jump
func jump():
	velocity.y -= 40


# check raycast and process paper like rotation
func _process(_delta):
	top_block = $RayTop.is_colliding()
	
	$Sprite.scale.x = lerp($Sprite.scale.x, flip_lerp, 0.1)
	
	# color animation when taking damage
	if $Sprite.modulate != Color(1, 1, 1) and not wait_timer:
		wait_timer = true
		$ColorTimer.start()
	
	if health <= 0:
		if direction == 1:
			$AnimationPlayer.play("death1")
		if direction == -1:
			$AnimationPlayer.play("death-1")


# physics
func _physics_process(_delta):
	if is_on_wall():
		if not top_block: jump()
		else: rotate_zombie()

	velocity.y += weight
	
	if not $AnimationPlayer.is_playing(): 
		velocity.x = speed * direction
	else: velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector2.UP)


# time zombie stays red
func _on_ColorTimer_timeout():
	$Sprite.modulate = Color(1, 1, 1)
	wait_timer = false


# when dead animation ends, remove the zombie from the scene
func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
