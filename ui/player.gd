extends CharacterBody2D

var bullet = preload("res://Player/Bullet/bullet.tscn")
var player_death_effect = preload("res://Player/player_death_effect.tscn")
var game_over_scene = preload("uid://b3o4woxpwukw")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle: Marker2D = $muzzle
@onready var hit_animation_player: AnimationPlayer = $HitAnimationPlayer

const GRAVITY = 1000
@export var speed : int = 1000
@export var max_horizontal_speed : int = 300
@export var slow_down_speed : int = 1500

@export var jump : int = -300
@export var jump_horizontal_speed : int = 1000
@export var max_jump_horizontal_speed : int = 300

enum State { Idle, Run, Jump, Shoot }

var current_state : State
var muzzle_position

func _ready() -> void:
	print("Testing GameOver path:", game_over_scene)
	current_state = State.Idle
	muzzle_position = muzzle.position
	

func _physics_process(delta: float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	player_muzzle_position(delta)
	player_shooting(delta)
	
	move_and_slide()
	
	player_animations()
	
	#print("State: ", State.keys()[current_state])

func player_falling(delta: float):
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		
func player_idle(delta: float):
	# ✅ Only set Idle if ON FLOOR and not moving
	if is_on_floor() and velocity.x == 0:
		current_state = State.Idle

func player_run(delta: float):
	# ✅ Only allow Run when ON FLOOR
	if is_on_floor():
		var direction = input_movement()
		
		if direction:
			velocity.x += direction * speed * delta
			current_state = State.Run
			animated_sprite_2d.flip_h = direction < 0
			velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
		else:
			velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)

func player_jump(delta: float):
	# ✅ Require ON FLOOR to start a jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump
		current_state = State.Jump
		
	# ✅ Allow horizontal control while airborne
	if !is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)

func player_shooting(delta: float):
	var direction = input_movement()
	
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
	
	# determine direction from facing
		if animated_sprite_2d.flip_h:
			bullet_instance.direction = -1  # facing left
		else:
			bullet_instance.direction = 1   # facing right

		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
	
		current_state = State.Shoot

		
	if direction != 0 and Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		current_state = State.Shoot

func player_muzzle_position(delta: float):
	var direction = input_movement()
	
	if direction > 0:
		muzzle_position.x = muzzle_position.x
	elif direction < 0:
		muzzle_position.x = -muzzle_position.x

func player_animations():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Run and animated_sprite_2d.animation != "run_shoot":
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("run_shoot")

func player_death():
	print("Player death triggered!")  # <--- Add this line

	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)

	queue_free()

	var game_over_instance = game_over_scene.instantiate()
	print("GameOver instance created")  # <--- Add this line
	get_tree().root.add_child(game_over_instance)
	get_tree().paused = true


	
func input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	
	return direction


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy Entered", body.damage_amount)
		hit_animation_player.play("hit")
		HealthManager.decrease_health(body.damage_amount)
		
	if HealthManager.current_health == 0:
		player_death()

func reset_after_hit():
	# This resets your player back to normal after hit animation
	animated_sprite_2d.modulate = Color(1, 1, 1, 1) # Remove red tint
	print("Player reset after hit")
