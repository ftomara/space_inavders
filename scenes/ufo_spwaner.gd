extends Node2D
@onready var spawn_timer = $spawnTimer
var ufo_scene : PackedScene = preload("res://scenes/ufo.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	(spawn_timer as SpawnTimer).setup_timer()



func _on_spawn_timer_timeout():
	var ufo = ufo_scene.instantiate()
	ufo.global_position = position
	get_tree().root.add_child(ufo)
