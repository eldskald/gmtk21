extends KinematicBody2D

export(int) var scheme_model

export(float) var MAX_HORIZONTAL_VELOCITY
export(float) var VERTICAL_VELOCITY

export(float) var GRAVITY_ACCELERATION
export(float) var JUMP_ACCELERATION
export(float) var HORIZONTAL_ACCELERATION
export(float) var HORIZONTAL_DEACCELERATION

enum {IDLE, MOVING, JUMPING, AIRBORNE, GRABBING, CUTSCENE}

onready var next_state: int = IDLE setget change_state
onready var active : bool = true
onready var scheme = player_schemes[scheme_model]

func change_state(new_value: int):
	next_state = new_value

enum {UP, DOWN, LEFT, RIGHT, JUMP, GRAB}

var player_idle = ["","","","","",""]
var player_one = ["up","down","left","right","jump","grab"]
var player_two = ["up_2","down_2","left_2","right_2","jump_2", "grab_2"]

var player_schemes = [player_idle, player_one, player_two]

var partner: KinematicBody2D
var chain_size: float
var velocity := Vector2.ZERO

func _physics_process(delta):
	print(next_state)
	var movement_input:Vector2 = get_movement_input()
	velocity.y += GRAVITY_ACCELERATION*delta
	match next_state:
		IDLE:
			if movement_input.x == 0:
				if self.velocity.x != 0:
					if sign(velocity.x) != sign(velocity.x - sign(velocity.x)*HORIZONTAL_DEACCELERATION*delta):
						velocity.x = 0
					else:
						velocity.x += -sign(velocity.x)*HORIZONTAL_DEACCELERATION*delta
			else:
				next_state = MOVING
			
		MOVING:
			if extending_rope_horizontally(movement_input):
					velocity.x = 0
			
			elif movement_input.x:
				if sign(movement_input.x) != sign(velocity.x) and velocity.x != 0:
					velocity.x += HORIZONTAL_DEACCELERATION*delta *movement_input.x
				if abs(velocity.x) < MAX_HORIZONTAL_VELOCITY:
					velocity.x += HORIZONTAL_ACCELERATION * delta *movement_input.x
				else:
					velocity.x = sign(velocity.x) * MAX_HORIZONTAL_VELOCITY
			else:
				next_state = IDLE
		JUMPING:
			pass
		AIRBORNE:
			pass
		GRABBING:
			pass
		CUTSCENE:
			pass
	velocity = move_and_slide(velocity, Vector2.UP)

func extending_rope_horizontally(movement_input: Vector2) -> bool:
	if partner != null:
		return (partner.position - self.position).length() >= chain_size and (
				sign(self.position.x - partner.position.x) == sign(movement_input.x) or 
				sign(self.position.x - partner.position.x) == sign(velocity.x))
	else:
		return false

func get_movement_input() -> Vector2:
	return Vector2(Input.get_action_strength(scheme[RIGHT]) - Input.get_action_strength(scheme[LEFT]),
	Input.get_action_strength(scheme[DOWN])-Input.get_action_strength(scheme[UP]))
