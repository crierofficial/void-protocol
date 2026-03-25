extends CharacterBody2D

const TILE_SIZE: float = 64.0
const MOVE_SPEED: float = 256.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_hp: int = 100
var max_hp: int = 100
var is_hacking: bool = false
var is_cloaked: bool = false

var current_weapon: Node = null
var gadgets: Array = []
var selected_gadget: int = 0

var player_id: int = 0

enum PlayerClass { ENGINEER, GHOST, TANK, OVERLOAD }
var player_class: PlayerClass = PlayerClass.ENGINEER

func _ready() -> void:
	add_to_group("player")
	setup_class()
	equip_default_weapon()

func setup_class() -> void:
	match player_class:
		PlayerClass.TANK:
			max_hp = 150
			current_hp = 150
		PlayerClass.GHOST:
			MOVE_SPEED = MOVE_SPEED * 1.1

func _physics_process(delta: float) -> void:
	var input_dir := get_input_direction()
	
	if input_dir != Vector2.ZERO:
		velocity = input_dir * MOVE_SPEED
		update_facing(input_dir)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, MOVE_SPEED * delta)
	
	move_and_slide()
	handle_attack()

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

func handle_attack() -> void:
	if Input.is_action_pressed("attack") and current_weapon:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - position).normalized()
		current_weapon.fire(position, direction)

func update_facing(direction: Vector2) -> void:
	if direction.x > 0:
		sprite.scale.x = 1
	elif direction.x < 0:
		sprite.scale.x = -1

func take_damage(amount: int) -> void:
	if player_class == PlayerClass.TANK:
		amount = int(amount * 0.85)
	
	current_hp -= amount
	print("Player HP: ", current_hp, "/", max_hp)
	if current_hp <= 0:
		die()

func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
	print("Healed! HP: ", current_hp, "/", max_hp)

func die() -> void:
	print("Player died!")
	queue_free()

func start_hacking() -> void:
	is_hacking = true

func stop_hacking() -> void:
	is_hacking = false

func equip_default_weapon() -> void:
	current_weapon = Weapon.new()
	current_weapon.weapon_type = Weapon.WeaponType.PLASMA_PISTOL
	current_weapon.setup_weapon()
	add_child(current_weapon)

func pickup_weapon(weapon_id: String) -> void:
	print("Picked up weapon: ", weapon_id)

func pickup_gadget(gadget_id: String) -> void:
	print("Picked up gadget: ", gadget_id)
	if gadgets.size() < 4:
		gadgets.append(gadget_id)

func refill_ammo() -> void:
	if current_weapon:
		current_weapon.reload()
	print("Ammo refilled")

func use_gadget(index: int) -> void:
	if index < gadgets.size():
		print("Using gadget: ", gadgets[index])
