extends Area2D

class_name Projectile

var speed: float = 400.0
var direction: Vector2 = Vector2.RIGHT
var damage: int = 15
var owner_id: int = 0
var lifetime: float = 3.0
var lifetime_timer: float = 0.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	position += direction * speed * delta
	
	lifetime_timer += delta
	if lifetime_timer >= lifetime:
		queue_free()

func setup(_direction: Vector2, _damage: int, _owner_id: int) -> void:
	direction = _direction.normalized()
	damage = _damage
	owner_id = _owner_id
	
	if direction.x < 0:
		scale.x = -1

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var player = area.get_parent()
		if player.get_instance_id() != owner_id:
			player.take_damage(damage)
			queue_free()
	elif area.is_in_group("environment"):
		queue_free()
	elif area.is_in_group("projectile"):
		if area.owner_id != owner_id:
			queue_free()
