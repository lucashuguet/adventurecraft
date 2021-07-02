extends KinematicBody2D

export var direction = 1
var weight = 15
var speed = 100
var velocity = Vector2()

func _ready():
	if direction == -1:
		$Sprite.flip_h = true
func _physics_process(_delta):
	if is_on_wall():
		direction = direction * -1
		$Sprite.flip_h = not $Sprite.flip_h

	velocity.y += weight
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
