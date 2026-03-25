extends CharacterBody2D

const TILE_SIZE: float = 64.0
const MOVE_SPEED: float = 256.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_hp: int = 100
var max_hp: int = 100
var is_hacking: bool = false
var is_cloaked: bool = false

enum PlayerClass { ENGINEER, GHOST, TANK, OVERLOAD }
var player_class: PlayerClass = PlayerClass.ENGINEER

func _ready() -> void:
	setup_class()

func setup_class() -> void:
	match player_class:
		PlayerClass.TANK:
			max_hp = 150
			current_hp = 150

func _physics_process(delta: float) -> void:
	var input_dir := get_input_direction()
	
	if input_dir != Vector2.ZERO:
		velocity = input_dir * MOVE_SPEED
		update_facing(input_dir)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_SPEED * delta)
	
	move_and_slide()

func get_input_direction() -> Vector2:
	var input := Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		input.y -= 1
	if Input.is_action_pressed("move_down"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1
	
	if input != Vector2.ZERO:
		return input.normalized()
	return Vector2.ZERO

func update_facing(direction: Vector2) -> void:
	if direction.x > 0:
		sprite.scale.x = 1
	elif direction.x < 0:
		sprite.scale.x = -1

func take_damage(amount: int) -> void:
	current_hp -= amount
	if current_hp <= 0:
		die()

func die() -> void:
	queue_free()

func start_hacking() -> void:
	is_hacking = true

func stop_hacking() -> void:
	is_hacking = false
