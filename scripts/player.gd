extends CharacterBody2D

var move_speed: float = 200.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * move_speed
		print("Moving: ", direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed * delta)
	
	move_and_slide()

func _ready():
	add_to_group("player")
	print("Player ready!")
