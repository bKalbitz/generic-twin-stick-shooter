extends Object
# Uils class with static methods
class_name Utils
# Name of animations ordered by angle of perspective.
const SPRITES = ["right",
	"down-right",
	"down",
	"down-left",
	"left",
	"up-left",
	"up",
	"up-right"]

# Returns animation name by the angle of the given vector.
static func get_sprite_name(velocity: Vector2) -> String:
	if velocity.length() == 0:
		return SPRITES[0]
	var angle = rad_to_deg(velocity.angle()) + 22.5
	var slice_dir = floor(angle / 45)
	return SPRITES[slice_dir]

# Loads a config file with a given name from the default user path.
static func load_config_file(name: String) -> ConfigFile:
	var file_path = to_config_file_name(name)
	var config = ConfigFile.new()
	var err = config.load(file_path)
	if err != OK:
		config.save(file_path)
	return config

# Saves a config file to the file with the given name to the default user path.
static func save_config_file(name: String, config: ConfigFile) -> void:
	config.save(to_config_file_name(name))

# Returns the file path of the config file by the name of the file without file ending.
static func to_config_file_name(file_name: String) -> String:
	return "user://" + file_name + ".cfg"
