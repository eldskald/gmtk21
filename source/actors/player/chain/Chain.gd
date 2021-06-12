extends Node2D
export(int) var chain_size
export(PackedScene) var chain_segment
export(PackedScene) var player_1
export(PackedScene) var player_2

func _ready():
	var before_segment 
	for i in range(chain_size):
		var chain_segment_instance:RigidBody2D = chain_segment.instance()
		chain_segment_instance.position.x = 10 * i + 5
		self.add_child(chain_segment_instance)
		if i == 0:
			$Player1End.node_b = chain_segment_instance.get_path()
		elif i <= chain_size-1:
			before_segment.get_node("PinJoint2D").node_b = chain_segment_instance.get_path()
		before_segment = chain_segment_instance
	var player_1_instance = player_1.instance()
	player_1_instance.position = $Player1End.position
	self.add_child(player_1_instance)
	$Player1End.node_a = player_1_instance.get_path()
	var player_2_instance = player_2.instance()
	player_2_instance.position.x = 10 * chain_size + 5
	self.add_child(player_2_instance)
	before_segment.get_node("PinJoint2D").node_b = player_2_instance.get_path()
	
