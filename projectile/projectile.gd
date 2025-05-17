extends CharacterBody2D

# Speed of projectile
const SPEED = 400.0
# Damage of projectile. Not used in this iteration of project.
const DAMAGE = 100.0
# Explosion scene to spawn an explosion if the projectile hits something.
var Explosion = preload("res://projectile/explosion.tscn")

# Sets position and direction of the projectile.
func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(SPEED, 0).rotated(rotation)

# Move projectile. If the project hits something:
# 1. call apply_damage if the node implements the method
# 2. Spawn explosion
# 3. Remove projectile from game
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("apply_damage"):
			collision.get_collider().apply_damage(DAMAGE)
		var exp = Explosion.instantiate()
		get_tree().root.add_child(exp)
		exp.start(position, 0.75, true)
		queue_free()
