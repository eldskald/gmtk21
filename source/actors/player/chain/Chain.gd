extends Node2D
export(int) var chain_size
export(PackedScene) var chain_segment

func _ready():
	self.position = Vector2(100, 100)
	var before_segment 
	for i in range(chain_size):
		var chain_segment_instance:RigidBody2D = chain_segment.instance()
		self.add_child(chain_segment_instance)
		if i == 0:
			$Player1End.node_b = chain_segment_instance.get_path()
		elif i < chain_size-1:
			before_segment.get_node("PinJoint2D").node_b = chain_segment_instance.get_path()
		chain_segment_instance.position.y = 4 * i
		before_segment = chain_segment_instance
