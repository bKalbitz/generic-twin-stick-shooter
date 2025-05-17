extends CanvasLayer

# Signal when start game button is pressed.
signal start_game
# Signal when the control types was changed.
signal set_control_type(controller: bool)
# Holds submitted score on the end of the game.
var last_submitted_score = null
# Object to hadnle high score logic.
var high_score

# Inits the high score logic when menu is loaded into game.
func _ready() -> void:
	$newScoreContainer.hide();
	high_score = HighScore.new()
	high_score.init()
	fill_highscore()

# Update the high score text shown.
func fill_highscore() -> void:
	$highScoreLabel.text = high_score.get_high_score_text()

# Emites 'start_game' when start is pressed.
func _on_start_button_pressed() -> void:
	start_game.emit()

# Shows score at end of game.
# Shows option to submit score to high score, if high enough.
func submit_score(newScore: int) -> void:
	$highScoreLabel.hide()
	$newScoreContainer/scoreLabel.text = "Final Score: " + str(newScore)
	$newScoreContainer/userName.clear()
	$newScoreContainer.show()
	
	if high_score.is_high_score(newScore):
		last_submitted_score = newScore
		$newScoreContainer/userName.show()
	else:
		last_submitted_score = null
		$newScoreContainer/userName.hide()

# Hides score from last game if OK button pressed,
# If a score was submitted it is also added to high score.
func _on_score_ok_button_pressed() -> void:
	if last_submitted_score:
		high_score.add_score(last_submitted_score, $newScoreContainer/userName.text)
		fill_highscore()
	$newScoreContainer.hide()
	$highScoreLabel.show()

# Called if the selection of the control type changed. Emits 'set_control_type'.
func _on_controls_select_item_selected(index: int) -> void:
	set_control_type.emit(index == 1)
