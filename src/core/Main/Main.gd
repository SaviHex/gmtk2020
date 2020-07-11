extends Node2D


var paths: Array
var characters: Array

func _ready() -> void:
	self.paths = $EnemyPaths.get_children()
	self.characters = $Characters.get_children()
	init_enemies()


func init_enemies():
	var i = 0
	for c in self.characters:
		if c.is_in_group("enemy"):
			c.init(self.paths[i])
		i += 1
