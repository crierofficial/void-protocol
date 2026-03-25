extends Node

signal player_ready(player_id: int)
signal match_started
signal match_ended(winner_id: int)

var players: Dictionary = {}
var current_match_time: float = 0.0
var game_state: String = "lobby"

enum GameClass { ENGINEER, GHOST, TANK, OVERLOAD }

var selected_class: GameClass = GameClass.ENGINEER

func _ready() -> void:
	print("VOID PROTOCOL initialized...")
	print("Game Manager ready.")

func start_match() -> void:
	game_state = "playing"
	current_match_time = 0.0
	emit_signal("match_started")

func _process(delta: float) -> void:
	if game_state == "playing":
		current_match_time += delta

func end_match(winner_id: int) -> void:
	game_state = "ended"
	emit_signal("match_ended", winner_id)
