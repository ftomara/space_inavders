extends Node2D
@onready var spawn_timer : SpawnTimer= $SpawnTimer
var projectile_scene = preload("res://scenes/invader_shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.setup_timer()
	spawn_timer.timeout.connect(on_spawn_timer_timeout)
func on_spawn_timer_timeout():
	var projectile = projectile_scene.instantiate() 
	var projectile_sprite = projectile.get_node("Sprite2D") as Sprite2D
	projectile_sprite.modulate = Color(0.67,0.2,0.2,1)
	projectile.global_position = global_position
	get_tree().root.add_child(projectile)
	spawn_timer.setup_timer()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
