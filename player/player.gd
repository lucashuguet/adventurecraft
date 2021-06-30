extends KinematicBody2D

signal grounded_updated(is_grounded)

var crosshair = load("res://gui/crosshair.png")
var sword = load("res://items/diamond_sword.png")

export var speed = 400
export var weight = 15
export var gravity = true
export var jump = -1000
 
var screen_size
var is_grounded
var velocity = Vector2()

var inventory = [[crosshair, "weapon" , 1], [sword, "weapon", 1]]
var current_slot = 0

func _ready():
	Input.set_custom_mouse_cursor(crosshair)
	
	screen_size = get_viewport_rect().size
	$AnimatedSprite.play()

func inventory_process(type):
	if type == "block":
		var cursor = ImageTexture.new()
		var block: Image = inventory[current_slot][0].get_data()
		block.resize(32, 32)
		cursor.create_from_image(block)                  
		Input.set_custom_mouse_cursor(cursor)
	else:
		Input.set_custom_mouse_cursor(inventory[current_slot][0])

func _process(_delta):
	if Input.is_action_just_released("scroll_up"):
		if current_slot == len(inventory)-1:
			current_slot = 0
		else:
			current_slot = current_slot + 1
		inventory_process(inventory[current_slot][1])
		
	if Input.is_action_just_released("scroll_down"):
		if current_slot == 0:
			current_slot = len(inventory)-1
		else:
			current_slot = current_slot - 1
		inventory_process(inventory[current_slot][1])
	
func _physics_process(_delta):
	if Input.is_action_pressed("right"):
		velocity.x = speed
	if Input.is_action_pressed("left"):
		velocity.x = -speed

	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0

	if gravity:
		velocity.y = velocity.y + weight

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump

	velocity = move_and_slide(velocity, Vector2.UP)

	velocity.x = lerp(velocity.x, 0, 0.2)

	var was_grounded = is_grounded
	is_grounded = is_on_floor()

	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("grounded_updated", is_grounded)
