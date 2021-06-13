extends Camera2D

onready var player_1 = get_tree().get_nodes_in_group("player1")[0]
onready var player_2 = get_tree().get_nodes_in_group("player2")[0]

var m_point:= Vector2()

func _physics_process(_delta):
	m_point = (player_1.position + player_2.position)*1/2
	self.position = m_point
