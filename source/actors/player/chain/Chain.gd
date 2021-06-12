extends Node2D
export(int) var chain_size
export(PackedScene) var chain_segment
export(PackedScene) var player_1
export(PackedScene) var player_2
export(Vector2) var blue_pos
export(Color) var blue
export(Color) var orange

#signal pinjoint_array_ready

#func _ready():
#	self.connect("pinjoint_array_ready", $ChainParticles,  "_on_pinjoint_array_ready")
#	var before_segment 
#	var pinjoints = [$Player1End]
#	for i in range(chain_size):
#		var chain_segment_instance:RigidBody2D = chain_segment.instance()
#		chain_segment_instance.position.x = 10 * i + 5
#		self.add_child(chain_segment_instance)
#		if i == 0:
#			$Player1End.node_b = chain_segment_instance.get_path()
#		elif i <= chain_size-1:
#			pinjoints.append(before_segment.get_node("PinJoint2D"))
#			before_segment.get_node("PinJoint2D").node_b = chain_segment_instance.get_path()
#		before_segment = chain_segment_instance
#	print(pinjoints.size())
#	$ChainParticles.pinjoints = pinjoints
#	emit_signal("pinjoint_array_ready")
#	var player_1_instance = player_1.instance()
#	player_1_instance.position = $Player1End.position
#	self.remove_child($Player1End)
#	self.add_child(player_1_instance)
#	player_1_instance.add_child(pinjoints[0])
#	pinjoints[0].node_a = player_1_instance.get_path()
#	var player_2_instance = player_2.instance()
#	player_2_instance.position.x = 10 * chain_size + 5
#	self.add_child(player_2_instance)
#	before_segment.get_node("PinJoint2D").node_b = player_2_instance.get_path()

var pinjoints_array = []

var softness = 0.2
var bias = 0.9

func _ready():
	var player_1_node = player_1.instance()
	var player_2_node = player_2.instance()
	player_1_node.position = blue_pos
	player_2_node.position = blue_pos + Vector2(chain_size * 10 + 10, 0)
	self.add_child(player_1_node)
	self.add_child(player_2_node)
	
	var pinjoint = PinJoint2D.new()
	pinjoint.softness = softness
	pinjoint.bias = bias
	pinjoint.disable_collision = true
	pinjoint.node_a = player_1_node.get_path()
	pinjoint.node_b = player_2_node.get_path()
	pinjoint.position = blue_pos + Vector2(5, 0)
	self.add_child(pinjoint)
	pinjoints_array.append(pinjoint)
	$Line.add_point(pinjoint.position)
	
	for i in range(chain_size):
		var link_node = chain_segment.instance()
		link_node.position = blue_pos + Vector2(i * 10 + 10, 0)
		link_node.get_node("Particles").color = lerp(blue, orange, float(i)/float(chain_size + 1))
		self.add_child(link_node)
		var new_joint = PinJoint2D.new()
		new_joint.softness = softness
		new_joint.bias = bias
		new_joint.disable_collision = true
		new_joint.node_a = link_node.get_path()
		new_joint.node_b = pinjoints_array[-1].node_b
		pinjoints_array[-1].node_b = link_node.get_path()
		new_joint.position = blue_pos + Vector2(i * 10 + 15, 0)
		self.add_child(new_joint)
		pinjoints_array.append(new_joint)
		$Line.add_point(new_joint.position)



func _process(_delta):
	for i in range(pinjoints_array.size()):
		var pos_a = get_node(pinjoints_array[i].node_a).position
		var pos_b = get_node(pinjoints_array[i].node_b).position
		$Line.set_point_position(i, (pos_a + pos_b)/2)




