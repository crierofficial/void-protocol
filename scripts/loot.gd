extends Area2D

class_name Loot

enum LootType { WEAPON, GADGET, HEALTH, AMMO }

@export var loot_type: LootType = LootType.WEAPON
@export var item_id: String = "plasma_pistol"
@export var item_name: String = "Plasma Pistol"

var lifetime: float = 60.0
var lifetime_timer: float = 0.0

func _ready() -> void:
	add_to_group("loot")
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	lifetime_timer += delta
	if lifetime_timer >= lifetime:
		despawn()

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		pickup(area.get_parent())

func pickup(player: Node) -> void:
	match loot_type:
		LootType.WEAPON:
			player.pickup_weapon(item_id)
		LootType.GADGET:
			player.pickup_gadget(item_id)
		LootType.HEALTH:
			player.heal(40)
		LootType.AMMO:
			player.refill_ammo()
	
	queue_free()

func despawn() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	queue_free()

static func create_weapon_loot(pos: Vector2, weapon_name: String) -> Loot:
	var loot = Loot.new()
	loot.position = pos
	loot.loot_type = LootType.WEAPON
	loot.item_id = weapon_name
	loot.item_name = weapon_name
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/kenney_space-shooter-redux/PNG/Power-ups/bolt_gold.png")
	loot.add_child(sprite)
	
	return loot
