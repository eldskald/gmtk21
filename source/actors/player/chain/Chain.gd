extends Node2D
export(int) var chain_size
export(PackedScene) var chain_segment
export(PackedScene) var player_1
export(PackedScene) var player_2

signal pinjoint_array_ready

func _ready():
	self.connect("pinjoint_array_ready", $ChainParticles,  "_on_pinjoint_array_ready")
	var before_segment 
	var pinjoints = [$Player1End]
	for i in range(chain_size):
		var chain_segment_instance:RigidBody2D = chain_segment.instance()
		chain_segment_instance.position.x = 10 * i + 5
		self.add_child(chain_segment_instance)
		if i == 0:
			$Player1End.node_b = chain_segment_instance.get_path()
		elif i <= chain_size-1:
			pinjoints.append(before_segment.get_node("PinJoint2D"))
			before_segment.get_node("PinJoint2D").node_b = chain_segment_instance.get_path()
		before_segment = chain_segment_instance
	print(pinjoints.size())
	$ChainParticles.pinjoints = pinjoints
	emit_signal("pinjoint_array_ready")
	var player_1_instance = player_1.instance()
	player_1_instance.position = $Player1End.position
	self.remove_child($Player1End)
	self.add_child(player_1_instance)
	player_1_instance.add_child(pinjoints[0])
	pinjoints[0].node_a = player_1_instance.get_path()
	var player_2_instance = player_2.instance()
	player_2_instance.position.x = 10 * chain_size + 5
	self.add_child(player_2_instance)
	before_segment.get_node("PinJoint2D").node_b = player_2_instance.get_path()
	
