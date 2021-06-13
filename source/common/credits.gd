extends Control

var fase: int = 0

func _input(event):
	if (event is InputEventJoypadButton or event is InputEventKey and event.is_pressed()) and !event.is_echo():
		fase += 1

func _process(delta):
	match fase:
		0:
			$MarginContainer/VBoxContainer.visible = true
			$MarginContainer/VBoxContainer2.visible = false
		1:
			$MarginContainer/VBoxContainer.visible = false
			$MarginContainer/VBoxContainer2.visible = true
		_:
			get_tree().quit()
