extends Node

export(Array, PackedScene) var levels
export(PackedScene) var credits

onready var i : int = 0

func load_level():
	i += 1
	if i < levels.size():
		get_tree().change_scene_to(levels[0])
	else:
		get_tree().change_scene_to(credits)
