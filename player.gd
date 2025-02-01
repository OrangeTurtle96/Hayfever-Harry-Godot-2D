extends CharacterBody2D

const SWORD_ATTACK = preload("attack.tscn")
const POLLEN_ATTACK = preload("pollen.tscn")

@export var movement_speed = 40
@export var attack_speed = 50
@export var attack_offset = 10
@export var max_health = 5
@export var defence = 1
@export var base_attack_damage = 1
@export var damage_multiplier = 1
var player_health
var input_direction = Vector2.ZERO
var attack_direction = Vector2.DOWN


func _ready() -> void:
	player_health == max_health


func _process(delta: float) -> void:
	#Checks if not attacking before processing Inputs
	if $"Attack Timer".is_stopped():
		#Player Movement Inputs
		if input_direction != Vector2.ZERO:
			attack_direction = input_direction
		velocity = Vector2.ZERO
		input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * movement_speed	
		#Player Attack Action
		if Input.is_action_pressed("attack"):
			_attackHandler(0)
		elif Input.is_action_pressed("interact")	:
			_attackHandler(1)
		#Player Collisions
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())	
		#Player Animation
		_animationHandler()


func _attackHandler(attack_type) -> void:
	velocity = Vector2.ZERO #Stops player movement
	$"Attack Timer".start()
	var attack;
	var isSprite = true #Stops trying to change properties of other elements which are only for sprites
	if attack_type == 1:
		isSprite = false
		attack = POLLEN_ATTACK.instantiate()
		attack.linear_velocity = attack_direction * attack_speed
	else:
		attack = SWORD_ATTACK.instantiate()


	attack.position = self.global_position + attack_direction * attack_offset
	attack.rotation = self.global_position.direction_to(attack.position).angle()	
	#Place sword above player when facing down and begind when facing up (assumes player at level 1)
	if attack_direction.y >= 0:
		attack.z_index = 1
	else:
		attack.position += Vector2(0,attack_offset/2)
		attack.z_index = 0
	if isSprite == true:
		if attack_direction.x < 0:
			attack.flip_v = true
		else:
			attack.flip_v = false
	#After setting properties of sword attack above it is spawned in...
	get_parent().add_child(attack)

func _animationHandler() -> void:
	if input_direction.y < 0 :
		if input_direction.x > 0:
			$PlayerSprite.play("up_right")
		elif input_direction.x < 0:
			$PlayerSprite.play("up_left")
		else:
			$PlayerSprite.play("up")
	elif input_direction.y > 0 :
		if input_direction.x > 0:
			$PlayerSprite.play("down_right")
		elif input_direction.x < 0:
			$PlayerSprite.play("down_left")
		else:
			$PlayerSprite.play("down")
	elif input_direction.x < 0:
		$PlayerSprite.play("left")
	elif input_direction.x > 0:
		$PlayerSprite.play("right")
	else:
		$PlayerSprite.stop()


func playerDeath() -> void:
	pass
