extends TileMapLayer

# Enemy scene to spawn new enemies.
var Enemy = preload("res://enemy/enemy.tscn")

# Object that holds logic to handle the enemy destroyed signal. 
var gameLogic

# Spawns new enemy when the spawn timer timed out.
# The destroy signal will be connected with the 'gameLogic' instance to handle the logic.
# Enemy will be spawned on a random location of the respawn path.
func _on_spawn_timer_timeout() -> void:
	var enemy = Enemy.instantiate()
	if gameLogic:
		enemy.connect("destroyed", Callable(gameLogic, "_on_enemy_destroyed"))
	var spawnLocaltion = $respawnPath/spawnLocation
	spawnLocaltion.progress_ratio = randf()
	enemy.position = spawnLocaltion.position
	get_tree().root.add_child(enemy)

# Hide level, stop spawn time and remove all enemies and projectiles from the game.
func deactivate() -> void:
	$spawnTimer.stop()
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("projectiles", "queue_free")
	hide()

# restrat spawn time and show level.
func reset() -> void:
	$spawnTimer.start()
	show()
