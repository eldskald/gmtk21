extends Node2D

export (PackedScene) var link_particles
export (Color) var orange
export (Color) var blue

var pinjoints

func _ready():
	for i in range(pinjoints.size() - 1):
		var link_vector = pinjoints[i + 1] - pinjoints[i]
		var new_link_particles: CPUParticles2D = link_particles.instance()
		new_link_particles.global_position = pinjoints[i].global_position + link_vector / 2
		new_link_particles.rotation = link_vector.angle()
		new_link_particles.emission_rect_extents.y = link_vector.length() / 2
		new_link_particles.amount = link_vector.length() / 2
		new_link_particles.get_child(0).points[0].y = link_vector.length() / 2
		new_link_particles.get_child(0).points[1].y = -link_vector.length() / 2
		new_link_particles.color = lerp(blue, orange, i / (pinjoints.size() - 1))
		self.add_child(new_link_particles)

func _process(_delta):
	for i in range(pinjoints.size() - 1):
		var link_vector = pinjoints[i + 1] - pinjoints[i]
		get_child(i).global_position = pinjoints[i].global_position + link_vector / 2
		get_child(i).rotation = link_vector.angle()
		get_child(i).emission_rect_extents.y = link_vector.length() / 2
		get_child(i).amount = link_vector.length() / 2
		get_child(i).get_child(0).points[0].y = link_vector.length() / 2
		get_child(i).get_child(0).points[1].y = -link_vector.length() / 2
		get_child(i).color = lerp(blue, orange, i / (pinjoints.size() - 1))
		


