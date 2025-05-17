extends Object
# Holds logic to load and persist the high score.
class_name HighScore
# Holds the last submitted score to add it to the high score when OK button is pressed.
var last_submitted_score = null
# Array holds score and player names of high score.
var high_score = [[0, "???"],
[0, "???"],
[0, "???"],
[0, "???"],
[0, "???"],
[0, "???"],
[0, "???"],
[0, "???"],
[0, "???"],
[0, "???"]]
# The config file that holds the high score. Loaded in init().
var scoreFile

# Loads 'scoreFile' and replace 'high_score' with its content.
func init() -> void:
	scoreFile = Utils.load_config_file("score")
	load_high_score() 

# Fills 'high_score' with content of 'scoreFile'.
func load_high_score() -> void:
	for i in high_score.size():
		var score = scoreFile.get_value("entry" + str(i),  "score", 0)
		var player = scoreFile.get_value("entry" + str(i),  "player", "???")
		high_score[i] = [score, player]

# Persists 'high_score' content into 'scoreFile'.
func save_high_score() -> void:
	for i in high_score.size():
		scoreFile.set_value("entry" + str(i),  "score", high_score[i][0])
		scoreFile.set_value("entry" + str(i),  "player", high_score[i][1])
	Utils.save_config_file("score", scoreFile)

# Returns current high score as rich text.
func get_high_score_text() -> String:
	var scores = "HIGHSCORE:"
	for entry in high_score:
		scores = scores + "\n" + entry[1] + ": " + str(entry[0])
	return scores

# Adds the new score submit to the high score, if it is a score higher a current entry.
func add_score(score: int, player: String) -> void:
	high_score.append([score, player])
	high_score.sort_custom(sort_by_score)
	high_score = high_score.slice(0, 10)
	save_high_score()

# Custom sort function for the 'high_score' array.
func sort_by_score(a, b) -> bool:
	if a[0] > b[0]:
		return true
	return false

# Returns true if the new score is higher than the lowest high score entry.
func is_high_score(newScore: int) -> bool:
	return high_score[high_score.size() - 1][0] < newScore
