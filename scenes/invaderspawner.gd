extends Node2D
class_name InvaderSpawner

signal invader_destroyed(points:int)
signal game_won
signal game_lost

const ROWS =5
const COL =11
const HS = 32
const VS = 32
const INV_H = 24
const START_Y_POS = -50
const INV_POS_X_INC =10
const INV_POS_Y_INC =20

var move_dir =1
var invader_scene = preload("res://scenes/invader.tscn")
var invader_shot_scene = preload("res://scenes/invader_shot.tscn")
@onready var movement_timer = $MovementTimer
@onready var shot_timer = $ShotTimer
@onready var explosion = $"../explosion"

var invader_destroyed_count =0
var invader_total_count = ROWS * COL

# Called when the node enters the scene tree for the first time.
func _ready():
	movement_timer.timeout.connect(move_invaders)
	shot_timer.timeout.connect(on_invader_shot)
	var invader_1_res = preload("res://Resources/invader_1.tres")
	var invader_2_res = preload("res://Resources/invader_2.tres")
	var invader_3_res = preload("res://Resources/invader_3.tres")
	var invader_config
	for row in ROWS:
		if row == 0:
			invader_config = invader_1_res
		elif row == 1 || row ==2:
			invader_config = invader_2_res
		elif row == 3 || row ==4:
			invader_config = invader_3_res
		var row_width = (COL * invader_config.width *3) + ((COL - 1)*HS)
		var start_x = (position.x - row_width)/2
		for col in COL:
			var x = start_x + (col*invader_config.width*3) + (col*HS)
			var y = START_Y_POS + (row*INV_H) + (row*VS)
			var spawn_pos = Vector2(x,y)
			spawn_invader(invader_config , spawn_pos)
			 
func spawn_invader(invader_config , spawn_postion:Vector2):
		var invader = invader_scene.instantiate() as Invader
		invader.config = invader_config
		invader.global_position = spawn_postion
		invader.invader_destroyed.connect(on_invader_destroyed)
		add_child(invader)
func move_invaders():
	position.x += INV_POS_X_INC* move_dir 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_leftwall_area_entered(area):
	if (move_dir == -1):
		position.y += INV_POS_Y_INC
		move_dir*=-1


func _on_rightwall_area_entered(area):
	if (move_dir == 1):
		position.y += INV_POS_Y_INC
		move_dir*=-1
	
func on_invader_shot():
	var random_child_pos = get_children().filter(func (child): return child is Invader).map(func (invader): return invader.global_position).pick_random()
	var invader_shot = invader_shot_scene.instantiate() as InvaderShot
	invader_shot.global_position = random_child_pos
	get_tree().root.add_child(invader_shot)
	#explosion.play()


func on_invader_destroyed(points : int):
	invader_destroyed.emit(points)
	invader_destroyed_count += 1
	if invader_destroyed_count == invader_total_count:
		game_won.emit()
		shot_timer.stop()
		movement_timer.stop()
		#explosion.stop()
		move_dir =0
		


func _on_bottomwall_area_entered(area):
	game_lost.emit()
	movement_timer.stop()
	move_dir =0
	
