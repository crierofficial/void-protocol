extends Node2D

class_name Room

@export var room_name: String = "Room"
@export var room_type: int = 0
@export var is_collapsible: bool = false
@export var is_collapsed: bool = false

@onready var floor_tiles: Node2D = $FloorTiles
@onready var walls: Node2D = $Walls

var grid_width: int = 4
var grid_height: int = 4
var tile_size: int = 64

func _ready() -> void:
	create_room()

func create_room() -> void:
	draw_floor()
	draw_walls()

func draw_floor() -> void:
	for y in range(grid_height):
		for x in range(grid_width):
			var tile = Sprite2D.new()
			tile.texture = load("res://assets/kenney_rpg-urban-pack/Tiles/floor_001.png")
			tile.position = Vector2(x * tile_size, y * tile_size)
			tile.modulate = get_room_color()
			floor_tiles.add_child(tile)

func draw_walls() -> void:
	for x in range(grid_width):
		var wall_top = create_wall(Vector2(x * tile_size, -tile_size/2))
		wall_top.rotation = 0
		walls.add_child(wall_top)
		
		var wall_bottom = create_wall(Vector2(x * tile_size, grid_height * tile_size - tile_size/2))
		wall_bottom.rotation = 0
		walls.add_child(wall_bottom)
	
	for y in range(grid_height):
		var wall_left = create_wall(Vector2(-tile_size/2, y * tile_size))
		wall_left.rotation = PI / 2
		walls.add_child(wall_left)
		
		var wall_right = create_wall(Vector2(grid_width * tile_size - tile_size/2, y * tile_size))
		wall_right.rotation = PI / 2
		walls.add_child(wall_right)

func create_wall(pos: Vector2) -> StaticBody2D:
	var body = StaticBody2D.new()
	body.position = pos
	
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/kenney_rpg-urban-pack/Tiles/wall_000.png")
	sprite.modulate = Color(0.5, 0.5, 0.6)
	body.add_child(sprite)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(tile_size, tile_size / 2)
	shape.shape = rect
	body.add_child(shape)
	
	return body

func get_room_color() -> Color:
	match room_type:
		0: return Color(0.3, 0.3, 0.35)
		1: return Color(0.4, 0.2, 0.2)
		2: return Color(0.2, 0.3, 0.4)
		3: return Color(0.3, 0.4, 0.3)
		4: return Color(0.2, 0.2, 0.3)
		5: return Color(0.3, 0.3, 0.4)
		6: return Color(0.25, 0.15, 0.15)
	return Color(0.3, 0.3, 0.35)

func collapse() -> void:
	if not is_collapsible:
		return
	
	is_collapsed = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
	await tween.finished
	queue_free()

func get_center() -> Vector2:
	return Vector2(grid_width * tile_size / 2, grid_height * tile_size / 2)
