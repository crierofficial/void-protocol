extends Node2D

@onready var player_scene = preload("res://scenes/player.tscn")

var player: CharacterBody2D
var rooms: Array = []

const GRID_OFFSET = Vector2(200, 100)
const ROOM_SPACING = 320

var ui_label: Label

func _ready() -> void:
	create_ui()
	create_station_map()
	spawn_player(Vector2(500, 400))

func create_ui() -> void:
	ui_label = Label.new()
	ui_label.position = Vector2(20, 20)
	ui_label.text = "VOID PROTOCOL\nWASD to move\nClick to attack"
	ui_label.modulate = Color(0, 1, 0.8)
	add_child(ui_label)

func create_station_map() -> void:
	var room_positions = {
		"bridge": Vector2(1, 0),
		"reactor": Vector2(1, 1),
		"cargo": Vector2(0, 1),
		"medbay": Vector2(2, 1),
		"engine": Vector2(0, 2),
		"cryo": Vector2(2, 2),
		"outer": Vector2(0, 3)
	}
	
	for room_name in room_positions:
		var pos = room_positions[room_name]
		var room = create_room(room_name, pos)
		rooms.append(room)

func create_room(room_name: String, grid_pos: Vector2) -> Node:
	var room = Node2D.new()
	room.name = room_name
	room.position = GRID_OFFSET + grid_pos * ROOM_SPACING
	add_child(room)
	
	for x in range(4):
		for y in range(4):
			var tile = Sprite2D.new()
			tile.texture = load("res://assets/kenney_rpg-urban-pack/Tiles/floor_001.png")
			tile.position = Vector2(x * 64, y * 64)
			tile.modulate = get_room_color(room_name)
			room.add_child(tile)
	
	create_walls(room)
	
	var label = Label.new()
	label.text = room_name.to_upper()
	label.position = Vector2(80, -30)
	room.add_child(label)
	
	return room

func create_walls(room: Node) -> void:
	var wall_positions = [
		Vector2(0, -32), Vector2(128, -32), Vector2(256, -32), Vector2(384, -32),
		Vector2(0, 256), Vector2(128, 256), Vector2(256, 256), Vector2(384, 256),
		Vector2(-32, 0), Vector2(-32, 128), Vector2(-32, 256),
		Vector2(256, 0), Vector2(256, 128), Vector2(256, 256)
	]
	
	for wall_pos in wall_positions:
		var wall = StaticBody2D.new()
		wall.position = wall_pos
		
		var sprite = Sprite2D.new()
		sprite.texture = load("res://assets/kenney_rpg-urban-pack/Tiles/wall_000.png")
		sprite.modulate = Color(0.4, 0.4, 0.5)
		wall.add_child(sprite)
		
		var shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.size = Vector2(64, 32)
		shape.shape = rect
		wall.add_child(shape)
		
		room.add_child(wall)

func get_room_color(room_name: String) -> Color:
	match room_name:
		"bridge": return Color(0.3, 0.3, 0.5)
		"reactor": return Color(0.5, 0.2, 0.2)
		"cargo": return Color(0.2, 0.3, 0.4)
		"medbay": return Color(0.3, 0.4, 0.3)
		"engine": return Color(0.2, 0.2, 0.3)
		"cryo": return Color(0.3, 0.3, 0.4)
		"outer": return Color(0.2, 0.1, 0.1)
	return Color(0.3, 0.3, 0.35)

func spawn_player(spawn_pos: Vector2) -> void:
	player = player_scene.instantiate()
	player.position = spawn_pos
	add_child(player)
	
	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	player.add_child(camera)
	
	print("Player spawned!")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("map_toggle"):
		print("Map toggle pressed")
