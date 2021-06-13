extends Node

var levels = []

enum {TITLE, GAME}

var state = TITLE


func _on_TextTimer_timeout():
	if $MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/Text.visible == true:
		$MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/Text.hide()
		$MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/HSeparator2.show()
		$TextTimer.start(0.2)
	else:
		$MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/HSeparator2.hide()
		$MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/Text.show()
		$TextTimer.start(0.4)
