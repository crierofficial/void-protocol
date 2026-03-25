extends Node2D

const TILE_WIDTH = 64
const TILE_HEIGHT = 32
const GRID_OFFSET_X = 340
const GRID_OFFSET_Y = 80

var player_scene = preload("res://scenes/player.tscn")
var player: CharacterBody2D

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
	draw_map()
	spawn_player()

func iso_to_screen(c, r):
	return Vector2(
		(c - r) * TILE_WIDTH / 2 + GRID_OFFSET_X,
		(c + r) * TILE_HEIGHT / 2 + GRID_OFFSET_Y
	)

func draw_map():
	for zone in zones:
		draw_zone(zone)
	for corr in corridors:
		draw_corridor(corr)
	
	draw_string(ThemeDB.fallback_font, Vector2(20, 30), "ARCTURUS STATION", HORIZONTAL_ALIGN_LEFT, -1, 20, Color(0, 0.83, 1))
	draw_string(ThemeDB.fallback_font, Vector2(20, 55), "VOID PROTOCOL - 7 ZONES", HORIZONTAL_ALIGN_LEFT, -1, 14, Color(0.5, 0.5, 0.5))

func draw_zone(z):
	var c = z.c
	var r = z.r
	var w = z.w
	var h = z.h
	var fl = z.fl
	var ac = z.ac
	
	var n = iso_to_screen(c, r)
	var e = iso_to_screen(c + w, r)
	var s = iso_to_screen(c + w, r + h)
	var wv = iso_to_screen(c, r + h)
	
	draw_polygon([n, e, s, wv], [fl])
	
	if z.has("danger"):
		var pulse = (sin(Time.get_ticks_msec() * 0.003) + 1) / 2
		draw_polygon([n, e, s, wv], [Color(0.867, 0.125, 0.125, pulse * 0.3)])
	
	draw_line(n, e, ac, 1.0)
	draw_line(e, s, ac.darkened(0.5), 1.0)
	draw_line(s, wv, ac.darkened(0.6), 1.0)
	draw_line(wv, n, ac.darkened(0.6), 1.0)
	
	draw_string(ThemeDB.fallback_font, Vector2((n.x + e.x + s.x + wv.x) / 4 - 40, n.y), z.name, HORIZONTAL_ALIGN_LEFT, -1, 10, ac)

func draw_corridor(c):
	var n = iso_to_screen(c.c, c.r)
	var e = iso_to_screen(c.c + c.w, c.r)
	var s = iso_to_screen(c.c + c.w, c.r + c.h)
	var wv = iso_to_screen(c.c, c.r + c.h)
	
	var col = Color(0.055, 0.055, 0.086)
	draw_polygon([n, e, s, wv], [col])
	
	draw_line(n, e, Color(0, 0.83, 0.5, 0.2), 0.5)
	draw_line(e, s, Color(0, 0.83, 0.5, 0.15), 0.5)

func spawn_player():
	player = player_scene.instantiate()
	var spawn_zone = zones[6]
	var center = iso_to_screen(spawn_zone.c + spawn_zone.w / 2.0, spawn_zone.r + spawn_zone.h / 2.0)
	player.position = center
	add_child(player)
	
	var cam = Camera2D.new()
	cam.position_smoothing_enabled = true
	player.add_child(cam)
