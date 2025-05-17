extends Node2D

# Scale of explosion sprite before starting the animation
const start_scale = Vector2(0.5, 0.5)

# Sets position and animation time. Plays explosion sound if 'hasSound' is true.
func start(_postion: Vector2, timeout: float, hasSound: bool) -> void:
	position = _postion
	$explosionTimer.start(timeout)
	if hasSound:
		$explosionSound.play()

# Scale explosion sprite bigger and add opaque during time.
# Remove explosion from game after timeout.
func _process(delta: float) -> void:
	var multiplayer = 2 - $explosionTimer.time_left / $explosionTimer.wait_time
	scale = Vector2(start_scale.x * multiplayer, start_scale.y * multiplayer)
	modulate.a = 2 - multiplayer
	if $explosionTimer.is_stopped():
		queue_free()
	
