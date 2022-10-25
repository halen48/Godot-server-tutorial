# Esse script deve ser configurado como <Auto Load>
# Configure-me em Projeto -> Configurações do Projeto -> AutoLoad
extends Node

const Utils = preload("res://src/utils.gd")

var ENet = NetworkedMultiplayerENet.new()
#Igual ao do servidor
var port : int = 42069
#IP da máquina que o servidor está ligado (no nosos caso, localhost)
var ip : String = "127.0.0.1"
var conectado : bool = false

func _ready():
	ConnectToServer()

func ConnectToServer():
	
	#Prepara a estrutura do cliente
	ENet.create_client(ip,port)	
	#Setter (get/set) de um ponto de conexão para preparar o servidor RPC
	get_tree().set_network_peer(ENet)
	#Associa uma função a um sinal (bind)
	ENet.connect('connection_failed', self, '_OnConexaoFalhou')
	ENet.connect('connected_to_server',self,'_OnTentandoConectar')
	ENet.connect('connection_succeeded', self, '_OnConexaoSucesso')
	
func _OnConexaoFalhou():
	print("Não conseguiu conectar ao servidor!")
	print("Tentando reconectar...")
	get_tree().set_network_peer(ENet)
	
func _OnConexaoSucesso():
	conectado = true
	print("Conexão estabelecida")
	#Carrega todos os Pawns
	var level = get_tree().get_root().get_node('Level')
	var pawn_factory = preload("res://assets/tscn/pawn.tscn").instance()
		
	var player = level.get_node('Player')
	var enemy = level.get_node('Enemy')
	for i in range(4):
		var pawn = pawn_factory.duplicate()
		if(i != 0):
			pawn.set_name("Pawn%d"%i)
		else:
			pawn.set_name("Pawn")
		pawn.pawn_class = i
		player.add_child(pawn)
				
	for i in range(4,8):
		var pawn = pawn_factory.duplicate()
		pawn.set_name("Pawn%d"%i)
		pawn.pawn_class = min(i,6)
		pawn.pawn_strategy = Utils.PAWN_STRATEGIES.keys()[randi() % Utils.PAWN_STRATEGIES.size()]
		enemy.add_child(pawn)

# =================================================================

# Envia um pacote para o servidor, requisitando suas respectivas infos.
# Parâmetro peer_id == 1, == mensagem para o servidor; 0 == Broadcast
func get_pawn_info(var pawn_class, var node_id):
	rpc_id(1, "get_pawn_info", pawn_class, node_id)
# =================================================================
remote func set_pawn_info(var info, var node_id):
	# Carrega o resto do personagem
	var n_id = instance_from_id(node_id)
	
	n_id.move_radious = info.move_radious
	n_id.jump_height = info.jump_height
	n_id.attack_radious = info.attack_radious
	n_id.attack_power = info.attack_power
	n_id.max_health = info.health
	n_id.curr_health = n_id.max_health
	n_id.translation = Vector3(info.x,info.y,info.z)
	
	n_id._load_animator_sprite()
	n_id.display_pawn_stats(false)
	n_id.set_process(true)
