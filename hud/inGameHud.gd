extends CanvasLayer

# score of current game
var score = 0

# Resets HUD to initial state.
func reset() -> void:
	score = 0
	$scoreLabel.text = str(score)
	show()

# Hides the HUD.
func deactivate() -> void:
	hide()

# Add the given points to the score shown by the HUD.
func add_score(add: int) -> void:
	score += add
	$scoreLabel.text = str(score)
