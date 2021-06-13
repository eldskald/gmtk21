extends Sprite

export (float) var wave_time = -1

func _process(_delta):
	$WaveAnimation.get_material().set_shader_param("time", wave_time)
