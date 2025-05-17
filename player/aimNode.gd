extends Node2D

# Current aim vetor
var aim = Vector2(100,0)
# Pixel distance from zero to start the aim indicator line.
const START = 70
# Pixel distance from zero to end the aim indicator line.
const END = START + 50

# draw line indicates the aim of the player.
func _draw():
	draw_line(Vector2(aim.x * START, aim.y * START), Vector2(aim.x * END, aim.y * END), Color.BEIGE, 2.0)

# Sets current aiming vector and re-draw the aim indicator.
func set_aim(new_aim: Vector2) -> void:
	aim = new_aim.normalized()
	queue_redraw()
