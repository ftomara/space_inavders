extends CanvasLayer

var life_texture = preload("res://Assets/Player/Player.png")
@onready var lifes_ui_container = $MarginContainer/HBoxContainer
@onready var points_label = $MarginContainer/points
@onready var points_counter = $"../PointsCounter" as PointsCounter
@onready var life_manger = $"../LifeManger" as LifeManger
@onready var invaderspawner = $"../invaderspawner" as InvaderSpawner
@onready var game_over_label = %GameOverLabel
@onready var game_over_button = %GameOverButton
@onready var game_over_container = $MarginContainer/GameOverContainer
@onready var loser = $"../loser"
@onready var winner = $"../winner"
@onready var explosion = $"../explosion"





func _ready():
	points_label.text = "SCORE: %d" %0
	points_counter.on_points_increased.connect(points_increased)
	invaderspawner.game_lost.connect(on_game_lost)
	invaderspawner.game_won.connect(on_game_won)
	game_over_button.pressed.connect(on_restart_button_pressed)
	life_manger.life_lost.connect(on_life_lost)
	
	for i in range(life_manger.lifes):
		var life_texture_rect = TextureRect.new()
		life_texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		life_texture_rect.custom_minimum_size = Vector2(40,25)
		life_texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		life_texture_rect.texture = life_texture
		lifes_ui_container.add_child(life_texture_rect)
	
	
	
func points_increased(points : int):
	points_label.text = "SCORE: %d" %points
func on_game_lost():
	game_over_container.visible = true
	loser.play()
	#get_tree().change_scene_to_file("res://scenes/endscreen.tscn")
	
	
func on_game_won():
	game_over_label.text = "YOU WON!"
	game_over_label.add_theme_color_override("font_color" , Color.MEDIUM_PURPLE)	
	game_over_container.visible = true	
	winner.play()
	#get_tree().change_scene_to_file("res://scenes/endscreen.tscn")

func on_restart_button_pressed():
	get_tree().reload_current_scene()
func on_life_lost(lifes_left: int):
	if lifes_left != 0:
		var lifes_texture_rect = lifes_ui_container.get_child(lifes_left)
		lifes_texture_rect.queue_free()
	else:
		on_game_lost()	
			


