extends Sprite

onready var shine = $Shine
onready var anim_player = $AnimationPlayer
onready var timer = $Timer

func _ready():
	timer.start(float(randi()%15)/10 + 1.5)

func _on_Timer_timeout():
	shine.position = Vector2(randi()%36 - 18, randi()%36 - 18)
	anim_player.play("shine")
	timer.start(float(randi()%15)/10 + 1.5)


