extends Node

export(Array, PackedScene) var levels
export(PackedScene) var credits

func load_level():
	if levels.size() > 0:
		get_tree().change_scene_to(levels.pop_front())
	else:
		get_tree().change_scene_to(credits)
