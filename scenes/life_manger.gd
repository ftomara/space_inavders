extends Node
class_name  LifeManger
signal  life_lost(lifes_left : int)
@export var lifes =3
@onready var player : Player = $"../player"
var player_scene = preload("res://scenes/player.tscn")

func _ready():
	(player as Player).player_destroyed.connect(on_player_destroyed)

func on_player_destroyed():
	lifes-=1
	life_lost.emit(lifes)
	if lifes != 0:
		player = player_scene.instantiate() as Player
		player.global_position = Vector2(0,302)
		player.player_destroyed.connect(on_player_destroyed)
		get_tree().root.get_node("main").add_child(player)
