extends RigidBody2D

enum {UP, DOWN, LEFT, RIGHT, JUMP, GRAB}

var player_idle = ["","","","","",""]
var player_one = ["up","down","left","right","jump","grab"]
var player_two = ["up_2","down_2","left_2","right_2","jump_2", "grab_2"]

var player_schemes = [player_idle, player_one, player_two]

export(int) var scheme_model
export(bool) var dbg

export(float) var MAX_HORIZONTAL_VELOCITY
export(float) var VERTICAL_VELOCITY

export(float) var JUMP_ACCELERATION
export(float) var HORIZONTAL_ACCELERATION
export(float) var HORIZONTAL_DEACCELERATION

enum {IDLE, MOVING, JUMPING, AIRBORNE, GRABBING, CUTSCENE}

onready var next_state: int = IDLE setget change_state
onready var active : bool = true
onready var scheme = player_schemes[scheme_model]

var grab_released:= true
var player_1
var player_2

func change_state(new_value: int):
	if self.dbg:
		print(new_value)
	next_state = new_value


func _integrate_forces(state) -> void:
	if !get_tree().get_nodes_in_group("player1").empty():
		player_1 = get_tree().get_nodes_in_group("player1")[0]
	if !get_tree().get_nodes_in_group("player2").empty():
		player_2 = get_tree().get_nodes_in_group("player2")[0]
	var is_on_ground = check_ground()
	var move_direction = get_move_direction()
	
	match next_state:
		IDLE:
			if can_grab() and Input.is_action_pressed(scheme[GRAB]):
				grab()
				return
			elif is_on_ground and Input.is_action_just_pressed(scheme[JUMP]):
				jump()
			elif state.linear_velocity.x != 0 and is_on_ground and move_direction.x == 0:
				state.add_central_force(Vector2(-self.applied_force.x, 0))
				state.add_central_force(Vector2(HORIZONTAL_DEACCELERATION*(-sign(state.linear_velocity.x))*mass, 0))
				if abs(state.linear_velocity.x) < 3:
					state.linear_velocity.x = 0
			elif move_direction.x != 0:
				change_state(MOVING)
			elif !is_on_ground:
				change_state(AIRBORNE)
		
#			if can_grab() and Input.is_action_pressed(scheme[GRAB]):
#				grab()
#				return
#			else:
#				if is_on_ground and Input.is_action_just_pressed(scheme[JUMP]):
#					jump()
#				elif is_on_ground and move_direction.x != 0:
#					next_state = MOVING
#				elif !is_on_ground:
#					next_state = AIRBORNE
			
		MOVING:
			if can_grab() and Input.is_action_pressed(scheme[GRAB]):
				grab()
				return
			elif move_direction.x != 0 and is_on_ground:
				if Input.is_action_just_pressed(scheme[JUMP]):
					jump()
				elif sign(state.linear_velocity.x) != move_direction.x and move_direction.x != 0:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_DEACCELERATION * mass)
				if abs(state.linear_velocity.x) < MAX_HORIZONTAL_VELOCITY:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_ACCELERATION * mass)
#				else:
#					state.linear_velocity.x = sign(state.linear_velocity.x)*MAX_HORIZONTAL_VELOCITY
			elif move_direction.x == 0:
				change_state(IDLE)
			elif !is_on_ground:
				change_state(AIRBORNE)
			
#			if can_grab() and Input.is_action_pressed(scheme[GRAB]):
#				grab()
#				return
#			elif is_on_ground:
#				add_central_force(Vector2(move_direction.x * HORIZONTAL_ACCELERATION * mass, 0))
#				if Input.is_action_just_pressed(scheme[JUMP]):
#					jump()
#				elif move_direction.x == 0:
#					next_state = IDLE
#			else:
#				next_state = AIRBORNE
		
		JUMPING:
			if can_grab() and Input.is_action_pressed(scheme[GRAB]):
				grab()
				return
			elif Input.is_action_just_released(scheme[JUMP]):
				apply_central_impulse(Vector2.DOWN * abs(state.linear_velocity.y) * 3/4 * mass)
			elif !is_on_ground:
				if self.linear_velocity.y > 0:
					change_state(AIRBORNE)
				elif (move_direction.x == 0 and state.linear_velocity.x != 0) or (sign(state.linear_velocity.x) != move_direction.x and move_direction.x != 0):
					state.add_central_force(Vector2(-self.applied_force.x, 0))
					state.add_central_force(Vector2(HORIZONTAL_DEACCELERATION/2*(-sign(state.linear_velocity.x))*mass, 0))
				elif move_direction.x != 0 and abs(state.linear_velocity.x) < MAX_HORIZONTAL_VELOCITY:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_ACCELERATION/2 * mass)
#				elif abs(state.linear_velocity.x) >= MAX_HORIZONTAL_VELOCITY:
#					state.linear_velocity.x = sign(state.linear_velocity.x)*MAX_HORIZONTAL_VELOCITY
			elif $JumpTimer.is_stopped():
				change_state(IDLE)
			
#			if can_grab() and Input.is_action_pressed(scheme[GRAB]):
#				grab()
#				return
#			elif !is_on_ground:
#				add_central_force(Vector2(move_direction.x * HORIZONTAL_ACCELERATION * mass / 2, 0))
#				if Input.is_action_just_released(scheme[JUMP]) and linear_velocity.y < 0:
#					apply_central_impulse(Vector2(0, linear_velocity.y * 3 / 4))
#					next_state = AIRBORNE
#				elif linear_velocity.y >= 0:
#					next_state = AIRBORNE
#			else:
#				next_state = MOVING
		
		AIRBORNE:
			if can_grab() and Input.is_action_pressed(scheme[GRAB]):
				grab()
				return
			elif !is_on_ground:
				if (move_direction.x == 0 and state.linear_velocity.x != 0) or (sign(state.linear_velocity.x) != move_direction.x and move_direction.x != 0):
					state.add_central_force(Vector2(-self.applied_force.x, 0))
					state.add_central_force(Vector2(HORIZONTAL_DEACCELERATION/2*(-sign(state.linear_velocity.x))*mass, 0))
				elif move_direction.x != 0 and abs(state.linear_velocity.x) < MAX_HORIZONTAL_VELOCITY:
					add_central_force(Vector2(move_direction.x, 0) * HORIZONTAL_ACCELERATION * mass)
#				elif abs(state.linear_velocity.x) >= MAX_HORIZONTAL_VELOCITY:
#					state.linear_velocity.x = sign(state.linear_velocity.x)*MAX_HORIZONTAL_VELOCITY
			else:
				next_state = IDLE
			
#			if can_grab() and Input.is_action_pressed(scheme[GRAB]):
#				grab()
#				return
#			elif !is_on_ground:
#				add_central_force(Vector2(move_direction.x * HORIZONTAL_ACCELERATION * mass / 2, 0))
#			else:
#				next_state = MOVING

		CUTSCENE:
			self.call_deferred("set_mode",MODE_STATIC)
			pass

func _input(event):
	if next_state == GRABBING and event.is_action_released(scheme[GRAB]) and !event.is_echo():
		change_state(IDLE)
		self.call_deferred("set_mode",MODE_CHARACTER)

func grab():
	change_state(GRABBING)
	self.call_deferred("set_mode",MODE_STATIC)

func jump(mod :int = 1):
	$JumpTimer.start()
	apply_central_impulse(Vector2.UP * JUMP_ACCELERATION * mass * mod)
	change_state(JUMPING)

func can_grab() -> bool:
	return (check_ground() or check_walls() or check_ceiling() or check_orbs()) and grab_released

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

func check_orbs() -> bool:
	for body in $WallDetector.get_overlapping_areas():
		if body.is_in_group("orb"):
			return true
	return false

func get_move_direction() -> Vector2:
	return Vector2(Input.get_action_strength(scheme[RIGHT]) - Input.get_action_strength(scheme[LEFT]),
	Input.get_action_strength(scheme[DOWN])-Input.get_action_strength(scheme[UP]))

func play_death():
	Bgm.get_node("DeathSound").play()
	var chain = get_parent()
	var level = get_tree().get_nodes_in_group("level")
	if !level.empty():
		level = level[0]
		level.death_animation()
	if chain.has_method("hide_line"):
		chain.hide_line()
	player_1.call_deferred("set_mode",MODE_KINEMATIC)
	player_2.call_deferred("set_mode",MODE_KINEMATIC)
	player_1.play_death_anim()
	player_2.play_death_anim()
	yield($AnimationPlayer, "animation_finished")
	get_tree().call_deferred("reload_current_scene")

func play_death_anim():
	$AnimationPlayer.play("Death")

func _on_Footstool_body_entered(_body):
	pass
#	if (body.is_in_group("player2") or body.is_in_group("player1")):
#		if body.next_state == AIRBORNE:
#			body.jump(2)
