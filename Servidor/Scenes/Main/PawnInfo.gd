extends Node

var qt_infos_loaded = {}

var player_x
var player_z
var enemy_x
var enemy_z

func _ready():
	player_x = range(-40,12,4)
	player_x.shuffle()
	player_z = range(-60,-40,5)
	player_z.shuffle()
	enemy_x = range(-14,18,4)
	enemy_x.shuffle()
	enemy_z = range(12,36,3)
	enemy_z.shuffle()

func get_player_pos(var i : int) -> Vector3:
	return Vector3(player_x[i]/10.0, 2.5, player_z[i]/10.0)

func get_enemy_pos(var i : int) -> Vector3:
	return Vector3(enemy_x[i]/10.0, 0.3, enemy_z[i]/10.0)

static func get_pawn_move_radious(var pawn_class):
	match pawn_class:
		0: return 3
		1: return 5
		2: return 4
		3: return 4
		4: return 5
		5: return 3
		6: return 4
	
static func get_pawn_jump_height(var pawn_class):
	match pawn_class:
		0: return 0.5
		1: return 3
		2: return 1
		3: return 1
		4: return 3
		5: return 0.5
		6: return 1

static func get_pawn_attack_radious(var pawn_class):
	match pawn_class:
		0: return 1
		1: return 6
		2: return 3
		3: return 3
		4: return 6
		5: return 1
		6: return 3

static func get_pawn_attack_power(var pawn_class):
	match pawn_class:
		0: return 20
		1: return 10
		2: return 12
		3: return 12
		4: return 10
		5: return 20
		6: return 12

static func get_pawn_health(var pawn_class):
	match pawn_class:
		0: return 50
		1: return 35
		2: return 30
		3: return 25
		4: return 35
		5: return 50
		6: return 30
