extends Node

class_name Weapon

signal weapon_fired(position: Vector2, direction: Vector2)
signal cooldown_ready()

enum WeaponType { PLASMA_PISTOL, ARC_RIFLE, SHOCK_BLADE, STASIS_LOCK, EMP_GRENADE, MICRO_TURRET, REFLECTOR_SHIELD, PROXIMITY_MINE }

@export var weapon_type: WeaponType = WeaponType.PLASMA_PISTOL
@export var damage: int = 15
@export var cooldown: float = 0.5
@export var range: float = 300.0
@export var projectile_speed: float = 400.0
@export var requires_aim: bool = false

var current_cooldown: float = 0.0
var can_fire: bool = true
var ammo: int = -1
var max_ammo: int = -1

func _ready() -> void:
	setup_weapon()

func setup_weapon() -> void:
	match weapon_type:
		WeaponType.PLASMA_PISTOL:
			damage = 15
			cooldown = 0.5
			range = 500.0
			requires_aim = false
			ammo = -1
		WeaponType.ARC_RIFLE:
			damage = 45
			cooldown = 3.0
			range = 400.0
			requires_aim = true
			ammo = 20
			max_ammo = 20
		WeaponType.SHOCK_BLADE:
			damage = 100
			cooldown = 1.0
			range = 50.0
			requires_aim = false
			ammo = -1
		WeaponType.STASIS_LOCK:
			damage = 0
			cooldown = 20.0
			range = 200.0
			requires_aim = true
			ammo = 3
			max_ammo = 3
		WeaponType.EMP_GRENADE:
			damage = 0
			cooldown = 15.0
			range = 150.0
			requires_aim = false
			ammo = 2
			max_ammo = 2
		WeaponType.MICRO_TURRET:
			damage = 10
			cooldown = 0.3
			range = 200.0
			requires_aim = false
			ammo = 1
			max_ammo = 1
		WeaponType.REFLECTOR_SHIELD:
			damage = 0
			cooldown = 10.0
			range = 0.0
			requires_aim = false
			ammo = 1
			max_ammo = 1
		WeaponType.PROXIMITY_MINE:
			damage = 60
			cooldown = 12.0
			range = 0.0
			requires_aim = false
			ammo = 2
			max_ammo = 2

func _process(delta: float) -> void:
	if not can_fire:
		current_cooldown -= delta
		if current_cooldown <= 0:
			can_fire = true
			current_cooldown = 0.0
			emit_signal("cooldown_ready")

func fire(position: Vector2, direction: Vector2) -> bool:
	if not can_fire:
		return false
	
	if ammo == 0:
		return false
	
	can_fire = false
	current_cooldown = cooldown
	
	if ammo > 0:
		ammo -= 1
	
	emit_signal("weapon_fired", position, direction)
	return true

func reload() -> void:
	if max_ammo > 0:
		ammo = max_ammo

func get_weapon_name() -> String:
	match weapon_type:
		WeaponType.PLASMA_PISTOL: return "Plasma Pistol"
		WeaponType.ARC_RIFLE: return "Arc Rifle"
		WeaponType.SHOCK_BLADE: return "Shock Blade"
		WeaponType.STASIS_LOCK: return "Stasis Lock"
		WeaponType.EMP_GRENADE: return "EMP Grenade"
		WeaponType.MICRO_TURRET: return "Micro Turret"
		WeaponType.REFLECTOR_SHIELD: return "Reflector Shield"
		WeaponType.PROXIMITY_MINE: return "Proximity Mine"
	return "Unknown"
