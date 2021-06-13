extends Node

export(Array, PackedScene) var levels

func load_level():
	if levels.size() > 0:
		get_tree().change_scene_to(levels.pop_front())
	else:
		final()

func final():
	print("Final")
	pass
