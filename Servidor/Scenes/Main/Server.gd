extends Node

# https://docs.godotengine.org/en/stable/classes/class_networkedmultiplayerenet.html

# https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html

var ENet = NetworkedMultiplayerENet.new()

#Limite do valor da porta = 0xFFFF
var port : int = 42069
#Número máximo de conexões simultâneas
var max_jogadores : int = 100

func _ready():
	StartServer()
	
func StartServer():
	#Prepara a estrutura do servidor
	ENet.create_server(port,max_jogadores)
	#Setter (get/set) de um ponto de conexão para preparar o servidor RPC
	get_tree().set_network_peer(ENet)
	print("Server ligado!")
		
	#Associa uma função a um sinal (bind)
	ENet.connect('peer_connected', self, '_conecta_jogador')
	ENet.connect('peer_disconnected', self, '_discon_jogador')
	
	
func _conecta_jogador(player_id):
	print(str(player_id), ' conectou')
	
func _discon_jogador(player_id):
	print(str(player_id), ' desconectou')

# <remote> é uma keyword para indicar que a função é executada remotamente,
# ou seja, um cliente pode chamar esta função.
# Geralmente é utilizada em conjunto da função rpc_id(...)

# <sync> é outra keyword bem utilizada para sincronizar os clientes com o servidor.
# Geralmente é utilizada em conjunto da função rpc(...)
remote func get_pawn_info(var pawn_class, var node_id):
	var info = {
		move_radious = $PawnInfo.get_pawn_move_radious(pawn_class),
		jump_height = $PawnInfo.get_pawn_jump_height(pawn_class),
		attack_radious = $PawnInfo.get_pawn_attack_radious(pawn_class),
		attack_power = $PawnInfo.get_pawn_attack_power(pawn_class),
		health = $PawnInfo.get_pawn_health(pawn_class),
		x = 0, y = 0, z = 0
	}
	
	var pos : Vector3
	if(pawn_class < 4):
		pos = $PawnInfo.get_player_pos(pawn_class)
	else:
		pos = $PawnInfo.get_enemy_pos(pawn_class)
		
	info.x = pos.x
	info.y = pos.y
	info.z = pos.z
	
	var sender_id = get_tree().get_rpc_sender_id()
	rpc_id(sender_id, "set_pawn_info", info, node_id)
	print('Enviando [', info, '] do pawn tipo ',pawn_class ,' para o nó [', node_id, '] do cliente [', sender_id,']')
