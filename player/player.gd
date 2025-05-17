extends CharacterBody2D

# signals game over if the player was hit.
signal game_over

# Speed of the player.
const SPEED = 300.0
# Pixel distance to start spawning a projectile to avoid colliding with enemy itself.
const PROJECTILE_DISTANCE = 80
# true if the player is controlled via a gamepad. Otherwise, the aiming will be done by mouse.
@export var use_controller = true
# Project scene to spawn projectiles when the player shoots.
var Projectile = preload("res://projectile/projectile.tscn")
# Holds the last non zero leangth aim vector.
var last_aim = Vector2(1,0)
# true if the player is not currently in the game.
var deactivated = false

# Resets player for the start of a new game.
func reset(startPostion: Vector2) -> void:
	position = startPostion
	velocity = Vector2.ZERO
	deactivated = false;
	show()

# Deactivates and hides player.
func deactivate() -> void:
	deactivated = true
	hide()
	last_aim = Vector2(1,0)
	$shootTimer.stop()

# Calculates movement and aiming direction, execute shoot logic.
func _physics_process(delta: float) -> void:
	if deactivated:
		return
	
	var motion = Vector2()
	motion.x = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	motion.y = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
	motion.y /= 2
	motion = motion.normalized() * SPEED
	if motion.length() > 0:
		$tank.play(Utils.get_sprite_name(motion))
		
	var aim = Vector2()
	if use_controller:
		aim.x = Input.get_action_strength("player_aim_right") - Input.get_action_strength("player_aim_left")
		aim.y = Input.get_action_strength("player_aim_down") - Input.get_action_strength("player_aim_up")
		aim.y /= 2
	else:
		var mousAim = get_global_mouse_position()
		aim.x = mousAim.x - position.x
		aim.y = mousAim.y - position.y
		
	if aim.length() > 0:
		last_aim = aim
		$aimNode.set_aim(aim)
		$turret.play(Utils.get_sprite_name(aim))
	
	shoot()
	set_velocity(motion)
	move_and_slide()
	
# Spawns a new projectile in aim direction if shoot action is pressed and shoot time has timed out.
func shoot() -> void:
	if Input.is_action_pressed("player_shoot") && $shootTimer.is_stopped():
		var direction = last_aim.normalized();
		var p = Projectile.instantiate()
		p.start(Vector2(position.x + direction.x * PROJECTILE_DISTANCE, position.y + direction.y * PROJECTILE_DISTANCE), direction.angle())
		get_tree().root.add_child(p)
		$shootSound.play()
		$shootTimer.start()

# Emits 'gamegame_over' when the player was hit by a projectile.
func apply_damage(damege: float) -> void:
	$gameOverSound.play()
	game_over.emit()
