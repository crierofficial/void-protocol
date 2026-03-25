extends Node2D

const TILE_SIZE = 64

var player_scene = preload("res://scenes/player.tscn")
var player: CharacterBody2D

var floor_tile = preload("res://assets/kenney_rpg-urban-pack/Tiles/tile_0000.png")
var wall_tile = preload("res://assets/kenney_rpg-urban-pack/Tiles/tile_0001.png")

var rooms = {
	"cryo": {"pos": Vector2(2, 2), "size": Vector2(4, 4), "color": Color(0.1, 0.2, 0.4), "spawn": true},
	"engine": {"pos": Vector2(2, 7), "size": Vector2(4, 4), "color": Color(0.3, 0.1, 0.1)},
	"cargo": {"pos": Vector2(2, 12), "size": Vector2(4, 4), "color": Color(0.1, 0.3, 0.1)},
	"reactor": {"pos": Vector2(8, 7), "size": Vector2(4, 4), "color": Color(0.4, 0.2, 0.0), "final": true},
	"medbay": {"pos": Vector2(14, 7), "size": Vector2(4, 4), "color": Color(0.1, 0.3, 0.2)},
	"bridge": {"pos": Vector2(8, 2), "size": Vector2(4, 4), "color": Color(0.2, 0.2, 0.4)},
	"outer": {"pos": Vector2(8, 16), "size": Vector2(6, 2), "color": Color(0.3, 0.05, 0.05), "danger": true},
}

var corridors = [
	{"from": "cryo", "to": "bridge", "x": 4, "y": 3, "w": 2, "h": 2},
	{"from": "cryo", "to": "engine", "x": 2, "y": 6, "w": 2, "h": 2},
	{"from": "engine", "to": "cargo", "x": 2, "y": 11, "w": 2, "h": 2},
	{"from": "engine", "to": "reactor", "x": 6, "y": 7, "w": 2, "h": 2},
	{"from": "reactor", "to": "medbay", "x": 12, "y": 7, "w": 2, "h": 2},
	{"from": "reactor", "to": "outer", "x": 8, "y": 15, "w": 2, "h": 2},
]

func _ready():
	create_map()
	spawn_player()
	create_ui()

func create_map():
	for room_id in rooms:
		var room = rooms[room_id]
		create_room(room_id, room.pos, room.size, room.color)
	
	for corr in corridors:
		create_corridor(corr)

func create_room(id, pos, size, color):
	for x in range(size.x):
		for y in range(size.y):
			create_floor_tile(pos.x + x, pos.y + y, color)
	
	create_walls_for_room(pos, size)

func create_floor_tile(x, y, color):
	var sprite = Sprite2D.new()
	sprite.texture = floor_tile
	sprite.position = Vector2(x * TILE_SIZE + 32, y * TILE_SIZE + 32)
	sprite.modulate = color
	add_child(sprite)

func create_walls_for_room(pos, size):
	var wall_positions = []
	
	for x in range(size.x):
		wall_positions.append(Vector2(pos.x + x, pos.y - 1))
		wall_positions.append(Vector2(pos.x + x, pos.y + size.y))
	
	for y in range(size.y):
		wall_positions.append(Vector2(pos.x - 1, pos.y + y))
		wall_positions.append(Vector2(pos.x + size.x, pos.y + y))
	
	for wp in wall_positions:
		create_wall(wp)

func create_corridor(c):
	for x in range(c.w):
		for y in range(c.h):
			create_floor_tile(c.x + x, c.y + y, Color(0.05, 0.05, 0.08))

func create_wall(grid_pos):
	var wall = StaticBody2D.new()
	wall.position = Vector2(grid_pos.x * TILE_SIZE + 32, grid_pos.y * TILE_SIZE + 32)
	wall.collision_layer = 4
	wall.collision_mask = 1
	
	var sprite = Sprite2D.new()
	sprite.texture = wall_tile
	sprite.modulate = Color(0.5, 0.5, 0.6)
	wall.add_child(sprite)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(TILE_SIZE, TILE_SIZE)
	shape.shape = rect
	wall.add_child(shape)
	
	add_child(wall)

func spawn_player():
	player = player_scene.instantiate()
	player.position = Vector2(3 * TILE_SIZE + 32, 3 * TILE_SIZE + 32)
	add_child(player)
	
	var cam = Camera2D.new()
	cam.position_smoothing_enabled = true
	player.add_child(cam)

func create_ui():
	var ui = Label.new()
	ui.name = "UI"
	ui.position = Vector2(20, 20)
	ui.text = "ARCTURUS STATION\nVOID PROTOCOL\n\nWASD to move"
	ui.add_theme_font_size_override("font_size", 16)
	ui.modulate = Color(0, 0.83, 1)
	add_child(ui)
