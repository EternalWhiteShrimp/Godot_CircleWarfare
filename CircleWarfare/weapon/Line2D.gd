extends Line2D

var glo_pos_history=Vector2()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	glo_pos_history=global_position
	pass # Replace with function body.

func _process(delta):
	add_point(Vector2(0,0))#增加一个起始点
	for i in range(get_point_count()-1):#循环路径次
	    set_point_position(i,get_point_position(i)+glo_pos_history-global_position)
	if get_point_count()>10:
		remove_point(0)
	global_rotation_degrees=0

	glo_pos_history=global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#开始绘制
func start_draw():
	clear_points()
	set_process(true)
	
#停止绘制
func stop_draw():
	set_process(false)
	clear_points()

