extends Node2D

onready var nav_2d:Navigation2D=$Navigation2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().call_group("enemy", "nav_Get_Path",nav_2d)
	$Player.connect("player_dead",$CanvasLayer,"player_dead")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CanvasLayer_continue_game():
	$Player.resurrection()
	pass # Replace with function body.
