extends Node2D

onready var player_1 = get_tree().get_nodes_in_group("player1")[0]
onready var player_2 = get_tree().get_nodes_in_group("player2")[0]


func _on_FinishLine_body_entered(body):
	if body.is_in_group("player1") or body.is_in_group("player2"):
		player_1.next_state = player_1.CUTSCENE
		player_2.next_state = player_2.CUTSCENE
		$FinishLine/Hole/AnimationPlayer.play("ripple")
		yield($FinishLine/Hole/AnimationPlayer, "animation_finished")
		LevelsHolder.load_level()
