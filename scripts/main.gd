extends Node2D

const TILE_WIDTH = 64
const TILE_HEIGHT = 32
const GRID_OFFSET_X = 340
const GRID_OFFSET_Y = 80

var player_scene = preload("res://scenes/player.tscn")
var player: CharacterBody2D

var floor_tile = preload("res://assets/kenney_rpg-urban-pack/Tiles/tile_0000.png")
var wall_tile = preload("res://assets/kenney_rpg-urban-pack/Tiles/tile_0001.png")

var zones = [
	{"id": "bridge", "c": 6, "r": 0, "w": 4, "h": 4, "fl": Color(0.043, 0.106, 0.212), "ac": Color(0.165, 0.447, 0.847), "name": "BRIDGE"},
	{"id": "cargo", "c": 0, "r": 6, "w": 4, "h": 4, "fl": Color(0.059, 0.094, 0.047), "ac": Color(0.176, 0.4, 0.133), "name": "CARGO BAY"},
	{"id": "reactor", "c": 6, "r": 6, "w": 4, "h": 4, "fl": Color(0.149, 0.071, 0.0), "ac": Color(0.878, 0.471, 0.0), "name": "REACTOR CORE"},
	{"id": "medbay", "c": 12, "r": 6, "w": 4, "h": 4, "fl": Color(0.031, 0.11, 0.071), "ac": Color(0.0, 0.69, 0.314), "name": "MED BAY"},
	{"id": "engine", "c": 0, "r": 12, "w": 4, "h": 4, "fl": Color(0.094, 0.031, 0.031), "ac": Color(0.769, 0.141, 0.0), "name": "ENGINE ROOM"},
	{"id": "cryo", "c": 6, "r": 12, "w": 4, "h": 4, "fl": Color(0.024, 0.047, 0.094), "ac": Color(0.0, 0.737, 0.831), "name": "CRYO PODS", "spawn": true},
	{"id": "outer", "c": 4, "r": 16, "w": 6, "h": 2, "fl": Color(0.09, 0.031, 0.031), "ac": Color(0.867, 0.125, 0.125), "name": "OUTER WALKWAYS", "danger": true},
]

var corridors = [
	{"c": 7, "r": 4, "w": 2, "h": 2},
	{"c": 4, "r": 7, "w": 2, "h": 2},
	{"c": 10, "r": 7, "w": 2, "h": 2},
	{"c": 1, "r": 10, "w": 2, "h": 2},
	{"c": 7, "r": 10, "w": 2, "h": 2},
	{"c": 7, "r": 14, "w": 2, "h": 2},
]

func _ready():
	create_zones_and_walls()
	spawn_player()
	create_ui()

func iso_to_screen(c, r):
	return Vector2(
		(c - r) * TILE_WIDTH / 2.0 + GRID_OFFSET_X,
		(c + r) * TILE_HEIGHT / 2.0 + GRID_OFFSET_Y
	)

func create_zones_and_walls():
	for zone in zones:
		create_zone(zone)
	for corr in corridors:
		create_corridor(corr)

func create_zone(z):
	var c = z.c
	var r = z.r
	var w = z.w
	var h = z.h
	
	for tile_x in range(w):
		for tile_y in range(h):
			var pos = iso_to_screen(c + tile_x, r + tile_y)
			var sprite = Sprite2D.new()
			sprite.texture = floor_tile
			sprite.position = pos
			sprite.modulate = z.fl
			sprite.scale = Vector2(2, 2)
			add_child(sprite)
	
	create_zone_outline(z)

func create_corridor(c):
	for tile_x in range(c.w):
		for tile_y in range(c.h):
			var pos = iso_to_screen(c.c + tile_x, c.r + tile_y)
			var sprite = Sprite2D.new()
			sprite.texture = floor_tile
			sprite.position = pos
			sprite.modulate = Color(0.055, 0.055, 0.086)
			sprite.scale = Vector2(2, 2)
			add_child(sprite)

func create_zone_outline(z):
	var c = z.c
	var r = z.r
	var w = z.w
	var h = z.h
	var ac = z.ac
	
	var corners = [
		iso_to_screen(c, r),
		iso_to_screen(c + w, r),
		iso_to_screen(c + w, r + h),
		iso_to_screen(c, r + h),
	]
	
	for i in range(4):
		var start = corners[i]
		var end = corners[(i + 1) % 4]
		draw_line(start, end, ac, 3.0)
		
		var mid = (start + end) / 2.0
		for j in range(1, 4):
			var wall_pos = start.lerp(end, j / 4.0)
			create_wall(wall_pos)

func create_wall(pos):
	var wall = StaticBody2D.new()
	wall.position = pos
	wall.collision_layer = 4
	
	var sprite = Sprite2D.new()
	sprite.texture = wall_tile
	sprite.modulate = Color(0.4, 0.4, 0.5)
	sprite.scale = Vector2(2, 2)
	wall.add_child(sprite)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(32, 16)
	shape.shape = rect
	wall.add_child(shape)
	
	add_child(wall)

func spawn_player():
	player = player_scene.instantiate()
	var spawn_zone = zones[5]
	var center = iso_to_screen(spawn_zone.c + spawn_zone.w / 2.0, spawn_zone.r + spawn_zone.h / 2.0)
	player.position = center
	add_child(player)
	
	var cam = Camera2D.new()
	cam.position_smoothing_enabled = true
	player.add_child(cam)

func create_ui():
	var ui = Label.new()
	ui.name = "UI"
	ui.position = Vector2(20, 20)
	ui.text = "ARCTURUS STATION\nVOID PROTOCOL\n\nWASD to move\nWalls added!"
	ui.add_theme_font_size_override("font_size", 16)
	ui.modulate = Color(0, 0.83, 1)
	add_child(ui)
