extends CharacterBody2D

const SWORD_ATTACK = preload("attack.tscn")

@export var movement_speed = 40
@export var attack_offset = 10
@export var max_health = 5
@export var defence = 1
@export var base_attack_damage = 1
@export var damage_multiplier = 1
var player_health
var input_direction = Vector2.ZERO
var attack_direction = Vector2.ZERO


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
			_swordAttack()		
		#Player Collisions
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())	
		#Player Animation
		_animationHandler()


func _swordAttack() -> void:
	velocity = Vector2.ZERO #Stops player movement
	$"Attack Timer".start()
	var sword_attack = SWORD_ATTACK.instantiate()
	sword_attack.position = self.global_position + attack_direction * attack_offset
	sword_attack.rotation = self.global_position.direction_to(sword_attack.position).angle()	
	#Place sword above player when facing down and begind when facing up (assumes player at level 1)
	if attack_direction.y >= 0:
		sword_attack.z_index = 1
	else:
		sword_attack.position += Vector2(0,attack_offset/2)
		sword_attack.z_index = 0
	if attack_direction.x < 0:
		sword_attack.flip_v = true
	else:
		sword_attack.flip_v = false
	#After setting properties of sword attack above it is spawned in...
	get_parent().add_child(sword_attack)


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
