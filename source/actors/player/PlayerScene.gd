extends RigidBody2D

enum {UP, DOWN, LEFT, RIGHT, JUMP, GRAB}

var player_idle = ["","","","",""]
var player_one = ["up","down","left","right","jump","grab"]
var player_two = ["up_2","down_2","left_2","right_2","jump_2", "grab_2"]

var player_schemes = [player_idle, player_one, player_two]

export(int) var scheme_model

export(float) var MAX_HORIZONTAL_VELOCITY
export(float) var VERTICAL_VELOCITY

export(float) var JUMP_ACCELERATION
export(float) var HORIZONTAL_ACCELERATION
export(float) var HORIZONTAL_DEACCELERATION

enum {IDLE, MOVING, JUMPING, AIRBORNE, GRABBING}

onready var next_state: int = IDLE
onready var active : bool = true
onready var scheme = player_schemes[scheme_model]

func _integrate_forces(state) -> void:
	var is_on_ground = check_ground()
	var move_direction = get_move_direction()
	
	
	match next_state:
		IDLE:
			if can_grab() and Input.is_action_just_pressed(scheme[GRAB]):
				grab()
				return
			elif is_on_ground and Input.is_action_just_pressed(scheme[JUMP]):
				jump()
			elif state.linear_velocity.x != 0 and is_on_ground and move_direction.x == 0:
				state.add_central_force(Vector2(-self.applied_force.x, 0))
				state.add_central_force(Vector2(HORIZONTAL_DEACCELERATION*(-sign(state.linear_velocity.x))*mass, 0))
				if abs(state.linear_velocity.x) < 3:
					state.linear_velocity.x = 0
			if move_direction.x != 0:
				next_state = MOVING
			elif !is_on_ground:
				next_state = JUMPING
		MOVING:
			if can_grab() and Input.is_action_just_pressed(scheme[GRAB]):
				grab()
				return
			elif move_direction.x != 0 and is_on_ground:
				if Input.is_action_just_pressed(scheme[JUMP]):
					jump()
				elif sign(state.linear_velocity.x) != move_direction.x and move_direction.x != 0:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_DEACCELERATION * mass)
				if abs(state.linear_velocity.x) < MAX_HORIZONTAL_VELOCITY:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_ACCELERATION * mass)
				else:
					state.linear_velocity.x = sign(state.linear_velocity.x)*MAX_HORIZONTAL_VELOCITY
			elif move_direction.x == 0:
				next_state = IDLE
			elif !is_on_ground:
				next_state = AIRBORNE
		JUMPING:
			if can_grab() and Input.is_action_just_pressed(scheme[GRAB]):
				grab()
				return
			elif Input.is_action_just_released(scheme[JUMP]) or $JumpTimer.is_stopped():
				self.linear_velocity.y /= 4
			if !is_on_ground:
				if self.linear_velocity.y > 0:
					next_state = AIRBORNE
				elif (move_direction.x == 0 and state.linear_velocity.x != 0) or (sign(state.linear_velocity.x) != move_direction.x and move_direction.x != 0):
					state.add_central_force(Vector2(-self.applied_force.x, 0))
					state.add_central_force(Vector2(HORIZONTAL_DEACCELERATION/2*(-sign(state.linear_velocity.x))*mass, 0))
				elif move_direction.x != 0 and abs(state.linear_velocity.x) < MAX_HORIZONTAL_VELOCITY/2:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_ACCELERATION/2 * mass)
				elif abs(state.linear_velocity.x) >= MAX_HORIZONTAL_VELOCITY/2:
					state.linear_velocity.x = sign(state.linear_velocity.x)*MAX_HORIZONTAL_VELOCITY/2
			else:
				next_state = IDLE
		AIRBORNE:
			self.gravity_scale = 6
			if can_grab() and Input.is_action_just_pressed(scheme[GRAB]):
				grab()
				return
			if !is_on_ground:
				if (move_direction.x == 0 and state.linear_velocity.x != 0) or (sign(state.linear_velocity.x) != move_direction.x and move_direction.x != 0):
					state.add_central_force(Vector2(-self.applied_force.x, 0))
					state.add_central_force(Vector2(HORIZONTAL_DEACCELERATION/2*(-sign(state.linear_velocity.x))*mass, 0))
				elif move_direction.x != 0 and abs(state.linear_velocity.x) < MAX_HORIZONTAL_VELOCITY:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_ACCELERATION/2 * mass)
				elif abs(state.linear_velocity.x) >= MAX_HORIZONTAL_VELOCITY:
					state.linear_velocity.x = sign(state.linear_velocity.x)*MAX_HORIZONTAL_VELOCITY
			else:
				self.gravity_scale = 1
				next_state = IDLE
		
#		GRABBING:
#			if Input.is_action_just_pressed(scheme[GRAB]):
#				print("RELEASE")
#				next_state = IDLE
#				self.call_deferred("set_mode",MODE_CHARACTER)
#	if scheme_model == 1:
#		print(next_state)

func _input(event):
	if next_state == GRABBING and event.is_action_pressed(scheme[GRAB]) and !event.is_echo():
		print("RELEASE")
		next_state = IDLE
		self.call_deferred("set_mode",MODE_CHARACTER)

func grab():
	print("GRAB")
	next_state = GRABBING
	self.call_deferred("set_mode",MODE_STATIC)
	print(next_state)

func jump():
	$JumpTimer.start()
	apply_central_impulse(Vector2.UP * JUMP_ACCELERATION * mass)
	next_state = JUMPING

func can_grab() -> bool:
	return check_ground() or check_walls() or check_ceiling()

func check_ground() -> bool:
	for body in $GroundDetector.get_overlapping_bodies():
		if body.is_in_group("ground"):
			return true
	return false

func check_walls() -> bool:
	for body in $WallDetector.get_overlapping_bodies():
		if body.is_in_group("ground"):
			return true
	return false

func check_ceiling() -> bool:
	for body in $CeilingDetector.get_overlapping_bodies():
		if body.is_in_group("ground"):
			return true
	return false

func get_move_direction() -> Vector2:
	return Vector2(Input.get_action_strength(scheme[RIGHT]) - Input.get_action_strength(scheme[LEFT]),
	Input.get_action_strength(scheme[DOWN])-Input.get_action_strength(scheme[UP]))
