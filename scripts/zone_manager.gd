extends Node

signal zone_collapsed(zone_name: String)
signal collapse_warning(zone_name: String, time_remaining: float)

enum Zone {
	REACTOR_CORE,
	BRIDGE,
	CARGO_BAY,
	MED_BAY,
	ENGINE_ROOM,
	CRYO_PODS,
	OUTER_WALKWAYS
}

var zones: Dictionary = {}
var active_zones: Array = []
var collapse_timers: Dictionary = {}

const COLLAPSE_SCHEDULE = {
	Zone.OUTER_WALKWAYS: 120.0,
	Zone.ENGINE_ROOM: 300.0,
	Zone.CARGO_BAY: 300.0,
	Zone.MED_BAY: 420.0,
	Zone.BRIDGE: 420.0
}

const ZONE_POSITIONS = {
	Zone.REACTOR_CORE: Vector2(3, 2),
	Zone.BRIDGE: Vector2(3, 0),
	Zone.CARGO_BAY: Vector2(0, 2),
	Zone.MED_BAY: Vector2(6, 2),
	Zone.ENGINE_ROOM: Vector2(0, 4),
	Zone.CRYO_PODS: Vector2(6, 4),
	Zone.OUTER_WALKWAYS: Vector2(0, 6)
}

const ZONE_NAMES = {
	Zone.REACTOR_CORE: "Reactor Core",
	Zone.BRIDGE: "Bridge",
	Zone.CARGO_BAY: "Cargo Bay",
	Zone.MED_BAY: "Med Bay",
	Zone.ENGINE_ROOM: "Engine Room",
	Zone.CRYO_PODS: "Cryo Pods",
	Zone.OUTER_WALKWAYS: "Outer Walkways"
}

var match_time: float = 0.0
var is_match_active: bool = false

func _ready() -> void:
	initialize_zones()

func initialize_zones() -> void:
	for zone in Zone.keys():
		var zone_enum = Zone.get(zone)
		zones[zone_enum] = {
			"active": true,
			"name": ZONE_POSITIONS[zone_enum],
			"grid_pos": ZONE_POSITIONS[zone_enum],
			"collapsed": false
		}
		active_zones.append(zone_enum)

func start_match() -> void:
	is_match_active = true
	match_time = 0.0
	initialize_zones()

func _process(delta: float) -> void:
	if not is_match_active:
		return
	
	match_time += delta
	
	for zone_enum in COLLAPSE_SCHEDULE:
		var collapse_time = COLLAPSE_SCHEDULE[zone_enum]
		var time_until_collapse = collapse_time - match_time
		
		if time_until_collapse > 0 and time_until_collapse <= 30:
			if not collapse_timers.has(zone_enum) or not collapse_timers[zone_enum]:
				collapse_timers[zone_enum] = true
				emit_signal("collapse_warning", ZONE_NAMES[zone_enum], time_until_collapse)
		
		if match_time >= collapse_time:
			collapse_zone(zone_enum)

func collapse_zone(zone_enum: Zone) -> void:
	if zones[zone_enum]["active"]:
		zones[zone_enum]["active"] = false
		zones[zone_enum]["collapsed"] = true
		active_zones.erase(zone_enum)
		emit_signal("zone_collapsed", ZONE_NAMES[zone_enum])
		print("ZONE COLLAPSED: ", ZONE_NAMES[zone_enum])

func is_zone_active(zone_enum: Zone) -> bool:
	return zones[zone_enum]["active"]

func get_active_zone_count() -> int:
	return active_zones.size()

func get_match_time_formatted() -> String:
	var minutes = int(match_time) / 60
	var seconds = int(match_time) % 60
	return "%02d:%02d" % [minutes, seconds]
