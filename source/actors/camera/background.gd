extends Sprite


func _physics_process(_delta):
	self.position = get_node("../Camera2D").get_camera_screen_center()

