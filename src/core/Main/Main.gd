extends Node2D


var paths: Array
var characters: Array

func _ready() -> void:
	self.paths = $EnemyPaths.get_children()
	self.characters = $Characters.get_children()
	init_enemies()

func init_player():
	pass

func init_enemies():
	var i = 0
	for c in self.characters:
		if c.is_in_group("enemy"):
			c.init(self.paths[i], get_next_char(i))
		i += 1

func get_next_char(i: int) -> Node2D:
	return self.characters[(i + 1) % self.characters.size()]
