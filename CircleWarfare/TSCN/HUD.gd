extends CanvasLayer
signal continue_game
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum States{COMMON,DEAD}
var current_state=States.COMMON
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func player_dead():
	get_tree().paused=true
	$Label.text="菜\n\n你死了！是否继续游戏！"
	$Button.text="继续游戏"
	$Label.show()
	$Button.show()
	

func _on_Button_pressed():
	get_tree().paused=false
	$Label.hide()
	$Button.hide()
	emit_signal("continue_game")
	pass # Replace with function body.
