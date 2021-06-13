extends Node

onready var title_label = $MarginContainer/CenterContainer/VBoxContainer/Label

func _ready():
	$MarginContainer/CenterContainer/VBoxContainer/Label.modulate.a = 0
	$IntroTimer.start()
	yield($IntroTimer,"timeout")
	$AnimationPlayer.play("FadeIN")
	yield($AnimationPlayer,"animation_finished")
	$TextTimer.start(1)

func _on_TextTimer_timeout():
	if $MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/Text.visible == true:
		$MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/Text.hide()
		$MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/HSeparator2.show()
		$TextTimer.start(0.2)
	else:
		$MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/HSeparator2.hide()
		$MarginContainer/CenterContainer/VBoxContainer/VBoxContainer/Text.show()
		$TextTimer.start(0.4)

func _input(event):
	if (event is InputEventJoypadButton or event is InputEventKey) and !event.is_echo():
		LevelsHolder.load_level()
