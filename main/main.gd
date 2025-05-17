extends Node2D


# Register self to level to handle enemy destroyd signal.
# Show the main menu.
func _ready() -> void:
	$level.gameLogic = self
	show_main_menu()

# Shows main menu.
func show_main_menu() -> void:
	$inGameHud.deactivate()
	$player.deactivate()
	$level.deactivate()
	$mainMenu.show()

# Propergate player position to enemies.
func _process(delta: float) -> void:
	var player_position = $player.position
	get_tree().call_group("enemies", "_set_target_position", player_position)

# Starts game when the start button was pressed.
func _on_main_menu_start_game() -> void:
	$mainMenu.hide()
	$inGameHud.reset()
	$level.reset()
	$player.reset(Vector2.ZERO)

# Shows main menu and handle high score handling when the player died.
func _on_player_game_over() -> void:
	$mainMenu.submit_score($inGameHud.score)
	show_main_menu()

# Add score to in-game HUD if enemy emits destroyed signal.
func _on_enemy_destroyed() -> void:
	$inGameHud.add_score(50)

# Propagate control type change to player logic.
func _on_main_menu_set_control_type(controller: bool) -> void:
	$player.use_controller = controller
