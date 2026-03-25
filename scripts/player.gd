extends CharacterBody2D

var move_speed: float = 180.0

@onready var sprite: Sprite2D = $Sprite2D

var walk_frames = 0
var facing_right = true

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * move_speed
		
		if direction.x > 0:
			sprite.scale.x = 1
			facing_right = true
		elif direction.x < 0:
			sprite.scale.x = -1
			facing_right = false
		
		walk_frames += 1
	else:
		velocity = Vector2.ZERO
		walk_frames = 0
	
	move_and_slide()

func _ready():
	add_to_group("player")
	print("Player ready! Move with WASD")
