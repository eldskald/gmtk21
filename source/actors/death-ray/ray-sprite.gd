extends Sprite



func _on_Timer_timeout():
	self.frame = (frame + randi()%2 + 1)%3
