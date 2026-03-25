extends Node2D

@onready var player_scene = preload("res://scenes/player.tscn")

var player: CharacterBody2D

func _ready() -> void:
	spawn_player()

func spawn_player() -> void:
	player = player_scene.instantiate()
	player.position = Vector2(400, 300)
	add_child(player)
	
	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	player.add_child(camera)
	
	print("Player spawned at position: ", player.position)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	draw_isometric_grid()

func draw_isometric_grid() -> void:
	var tile_size := 64
	var grid_width := 10
	var grid_height := 8
	
	for y in range(grid_height):
		for x in range(grid_width):
			var iso_pos := cart_to_iso(Vector2(x * tile_size, y * tile_size))
			draw_rect(
				Rect2(iso_pos.x, iso_pos.y, tile_size, tile_size),
				Color(0.1, 0.1, 0.15),
				true
			)

func cart_to_iso(cart: Vector2) -> Vector2:
	return Vector2(
		cart.x - cart.y,
		(cart.x + cart.y) / 2.0
	)
