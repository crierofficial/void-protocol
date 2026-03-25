extends CharacterBody2D

var move_speed = 180.0

@onready var sprite = $Sprite2D

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.y = Input.get_axis("move_up", "move_down")
	
	if input.length() > 0:
		input = input.normalized()
		velocity = input * move_speed
		
		if input.x > 0:
			sprite.scale.x = 1
		elif input.x < 0:
			sprite.scale.x = -1
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _ready():
	add_to_group("player")
	print("Player ready! Use WASD")
