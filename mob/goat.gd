extends KinematicBody2D

signal which_block_behind(pos, who)

export var direction = 1
var weight = 15
var speed = 100
var velocity = Vector2()

func _ready():
	if direction == -1:
		$Sprite.flip_h = true

func change_direction():
	direction = direction * -1
	$Sprite.flip_h = not $Sprite.flip_h

func rotate(block):
	if block == -1 and is_on_floor():
		change_direction()

func _process(_delta):
	emit_signal("which_block_behind", position, get_node("."))

func _physics_process(_delta):
	if is_on_wall():
		change_direction()

	velocity.y += weight
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
