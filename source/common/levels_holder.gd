extends Node

export(Array, PackedScene) var levels
export(PackedScene) var credits

onready var i : int = -1

onready var ready = false

func _ready():
	$Timer.start()

func load_level():
	i += 1
	if i < levels.size():
		get_tree().change_scene_to(levels[i])
	else:
		get_tree().change_scene_to(credits)


func _on_Timer_timeout():
	ready = true
