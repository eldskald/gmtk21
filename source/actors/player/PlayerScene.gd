extends RigidBody2D

enum {UP, DOWN, LEFT, RIGHT, JUMP}

var player_idle = ["","","","",""]
var player_one = ["up","down","left","right","jump"]
var player_two = ["up_2","down_2","left_2","right_2","jump_2"]

var player_schemes = [player_idle, player_one, player_two]

export(int) var scheme_model

export(float) var MAX_HORIZONTAL_VELOCITY
export(float) var VERTICAL_VELOCITY

export(float) var JUMP_ACCELERATION
export(float) var HORIZONTAL_ACCELERATION
export(float) var HORIZONTAL_DEACCELERATION

enum {IDLE, MOVING, AIR}

onready var next_state: int = IDLE
onready var active : bool = true
onready var scheme = player_schemes[scheme_model]

func _integrate_forces(state) -> void:
	var is_on_ground = state.get_contact_count() > 0 and int(state.get_contact_collider_position(0).y) >= int(global_position.y)
	var move_direction = get_move_direction()
	match next_state:
		IDLE:
			print("Moving")
			if state.linear_velocity.x != 0 and is_on_ground and move_direction.x == 0:
				state.add_central_force(Vector2(-self.applied_force.x, 0))
				state.add_central_force(Vector2(HORIZONTAL_DEACCELERATION*(-sign(state.linear_velocity.x))*mass, 0))
				if abs(state.linear_velocity.x) < 3:
					state.linear_velocity.x = 0
			elif move_direction.x != 0:
				next_state = MOVING
			elif is_on_ground and Input.is_action_just_pressed(scheme[JUMP]):
				jump()
			elif !is_on_ground:
				next_state = AIR
		MOVING:
			
			if move_direction.x != 0 and is_on_ground:
				if sign(state.linear_velocity.x) != move_direction.x and move_direction.x != 0:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_DEACCELERATION * mass)
				if abs(state.linear_velocity.x) < MAX_HORIZONTAL_VELOCITY:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_ACCELERATION * mass)
				elif is_on_ground and Input.is_action_just_pressed(scheme[JUMP]):
					jump()
				else:
					state.linear_velocity.x = sign(state.linear_velocity.x)*MAX_HORIZONTAL_VELOCITY
			elif move_direction.x == 0:
				next_state = IDLE
			elif !is_on_ground:
				next_state = AIR
		AIR:
			if !is_on_ground:
				if (move_direction.x == 0 and state.linear_velocity.x != 0) or (sign(state.linear_velocity.x) != move_direction.x and move_direction.x != 0):
					state.add_central_force(Vector2(-self.applied_force.x, 0))
					state.add_central_force(Vector2(HORIZONTAL_DEACCELERATION/2*(-sign(state.linear_velocity.x))*mass, 0))
				elif move_direction.x != 0 and abs(state.linear_velocity.x) < MAX_HORIZONTAL_VELOCITY:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_ACCELERATION/2 * mass)
				elif abs(state.linear_velocity.x) == MAX_HORIZONTAL_VELOCITY:
					state.linear_velocity.x = sign(state.linear_velocity.x)*MAX_HORIZONTAL_VELOCITY
			else:
				next_state = IDLE
func jump():
	print("pulou")
	apply_central_impulse(Vector2.UP * JUMP_ACCELERATION)
	next_state = AIR

func get_move_direction() -> Vector2:
	return Vector2(Input.get_action_strength(scheme[RIGHT]) - Input.get_action_strength(scheme[LEFT]),
	Input.get_action_strength(scheme[DOWN])-Input.get_action_strength(scheme[UP]))
