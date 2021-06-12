extends TileMap

func _ready():
	var angle_1 = deg2rad(randi() % 360)
	var length_1 = randi() % 10 + 2
	var angle_2 = deg2rad(randi()%360)
	var length_2 = randi() % 10 + 2
	get_material().set_shader_param("par1_vel", Vector2.RIGHT.rotated(angle_1) * length_1)
	get_material().set_shader_param("par2_vel", Vector2.RIGHT.rotated(angle_2) * length_2)

func _process(_delta):
	if get_tree().get_nodes_in_group("camera").size() > 0:
		var camera = get_tree().get_nodes_in_group("camera")[0]
		get_material().set_shader_param("camera_position", camera.get_camera_screen_center())

