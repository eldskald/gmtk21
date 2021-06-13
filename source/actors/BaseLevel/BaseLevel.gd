extends Node2D



func _on_FinishLine_body_entered(body):
	if body.is_in_group("player1") or body.is_in_group("player2"):
		LevelsHolder.load_level()
