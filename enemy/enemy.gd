extends CharacterBody2D

# Basic speed
const SPEED = 250.0
# Pixel distance to start spawning a projectile to avoid colliding with enemy itself.
const PROJECTILE_DISTANCE = 80
# Signal for a destroyed enemy.
signal destroyed
# Projectile scene to spawn shots,
var Projectile = preload("res://projectile/projectile.tscn")
# Explosion scene to spawn explosions if enemy is destroyed.
var Explosion = preload("res://projectile/explosion.tscn")
# position of player,
var target_postion: Vector2 = Vector2.ZERO
# Holds the last non zero leangth aim vector.
var last_aim = Vector2(1,0)

# Start shoot timer when instance was added to game.
func _ready() -> void:
	$shootTimer.start()

# Move and aim at player. If collide bounce off from obstacle.
func _physics_process(delta: float) -> void:
	var motion = position.direction_to(target_postion);
	if motion.length() > 0:
		last_aim = motion
		$turret.play(Utils.get_sprite_name(motion))
	
	if $collideTimer.is_stopped():
		motion = motion.normalized() * SPEED
		velocity = motion
	
	if velocity.length() > 0:
		$tank.play(Utils.get_sprite_name(velocity))

	var collision = move_and_collide(velocity * delta)
	if collision:
		$collideTimer.start()
		velocity = velocity.bounce(collision.get_normal())

# Sets the current position of player
func _set_target_position(new_position: Vector2) -> void:
	target_postion = new_position

# Hit by projectile. Emit destroy. Remove instance from game.
func apply_damage(damege: float) -> void:
	destroyed.emit()
	$deathSound.play()
	for i in 5:
		var exp = Explosion.instantiate()
		get_tree().root.add_child(exp)
		exp.start(Vector2(position.x + randf_range(-32.0, 32.0),
		 position.y + randf_range(-32.0, 32.0)),
		 randf_range(0.5, 1.5), false)
	queue_free()

# Shoot at player when timer timed out. Restart the timer.
func _on_shoot_timer_timeout() -> void:
	var direction = last_aim.normalized();
	var p = Projectile.instantiate()
	p.start(Vector2(position.x + direction.x * PROJECTILE_DISTANCE, position.y + direction.y * PROJECTILE_DISTANCE), direction.angle())
	get_tree().root.add_child(p)
	$shootSound.play()
