extends "res://Character/Character.gd"


var player=null#玩家
var path=PoolVector2Array()#路径
var nav_2d=null#寻路
var move_speed=100#移动速度
var move_distance : float=0#移动距离
var vec_to_player=Vector2()#与玩家之间的差距向量
onready var current_control_scope:float=200#当前怪物的仇恨范围
onready var attack_scope:float=50#攻击范围
onready var craw_anim=$craw/AnimationPlayer#动画播放器
onready var line_2d=$Line2D#线
onready var wait_timer=$waitTimer#是否移动的计时器
var original_glo_position=Vector2()#原来的全局位置
var is_extend_control_scope=false#是否扩展仇恨范围
export var extend_control_scope=400#扩展之后的仇恨范围
export var original_control_scope=200#原仇恨范围
export var is_horizontal=false#是否水平方向移动
export var move_scope=100#移动范围
var target_update=true#是否刷新目标点
var is_can_attack=true#是否可以攻击
func _ready():
	current_control_scope=original_control_scope
	$craw.connect("attack_finished", self, "_on_Weapon_attack_finished")#监控武器攻击是否完成
	original_glo_position=global_position
	wait_timer.wait_time =3
	pass
#据路径移动
func move_along_path(distance : float)->void:
	var start_point :=position
	
	for i in range(path.size()):
		var distance_to_next:=start_point.distance_to(path[0])#距离
		vec_to_player= player.global_position - global_position
		if current_state==STATES.STAGGER:#被攻击，就停止移动
			break
		if vec_to_player.length()<attack_scope:
			break
		if distance<=distance_to_next and distance>=0.0 :
			position=start_point.linear_interpolate(path[0],distance/distance_to_next)
			break
		distance-=distance_to_next
		start_point=path[0]
		path.remove(0)

		
		
#获取寻路路径
func nav_Get_Path(nav):
	nav.global_position=Vector2(0,0)
	nav_2d=nav
#运行
func _physics_process(delta):
	if(player==null):
		return
	
	move_distance = move_speed * delta
	vec_to_player= player.global_position - global_position
	#line_2d.global_position=Vector2(0,0)
	#line_2d.global_rotation_degrees=0
	if(is_can_attack==true):
		
		enemy_AI()
	

#怪物AI
func enemy_AI():
	
	if(vec_to_player.length()<current_control_scope and vec_to_player.length()>=attack_scope):
		if(is_extend_control_scope==true):
			current_control_scope=extend_control_scope
		else:
			current_control_scope=original_control_scope
		if(name=="BOOS1"):
		    print(11)
		look_at(player.global_position)
		path=nav_2d.get_simple_path(global_position,player.global_position)
		line_2d.points=path
		move_along_path(move_distance)
		is_extend_control_scope=true
	elif(vec_to_player.length()<attack_scope ):
		look_at(player.global_position)
		is_can_attack=false
		$craw.attack()
		if(name=="BOOS1"):
		    
		    print(22)
		pass
	else:
		is_extend_control_scope=false
		if(name=="BOOS1"):
		    print(vec_to_player.length())
		    print(33)
		common_move()
	
#附近没有玩家时的活动
func common_move():
	var target_gap=Vector2(0,0)#与目标的差距
	var target_glo_pos=Vector2(0,0)
	if(is_horizontal==false):#垂直方向的移动
		target_gap=Vector2(0,move_scope)
	else:#水平
	    target_gap=Vector2(move_scope,0)
	if(target_update==true):
		target_glo_pos=original_glo_position+target_gap
	else:
		target_glo_pos=original_glo_position-target_gap
	
	if((global_position-target_glo_pos).length()>10):
		var temp_vec=(target_glo_pos-global_position)
		if(is_horizontal==true):
			 global_rotation_degrees=(atan2(temp_vec.x,temp_vec.y)*180/3.1415926)-90
		else:
		    global_rotation_degrees=(atan2(temp_vec.x,temp_vec.y)*180/3.1415926)+90
		move_and_slide(temp_vec.normalized()*move_speed)
		
	else:
		wait_timer.start()
		set_physics_process(false)
	pass

#被攻击
func take_damage(weapon,count):
	if current_state == STATES.DEAD:
		return
	_change_state(STATES.STAGGER)
	health -= count
	if health <= 0:
		health = 0
		_change_state(STATES.DEAD)
		emit_signal("died")
		return
		
	if weapon=="knife":
		$Particles2D.rotation_degrees=180
		$Particles2D.position=Vector2(0,-6)
	if(weapon=="sword"):
		$Particles2D.rotation_degrees=90
		$Particles2D.position=Vector2(-6,0)
	$Particles2D.emitting=true
	
		
	_change_state(STATES.STAGGER)
	emit_signal("health_changed", health)
#死亡
func dead():
	set_physics_process(false)
	$Sprite.hide()
	$craw.hide()
	wait_timer.wait_time=0.5
	wait_timer.start()
	$AnimationPlayer.play("dead")
	$Particles2D.emitting=true
	
	
#自身的动画完成
func _on_AnimationPlayer_animation_finished(name):
	if(name=="take_damage"):
		_change_state(STATES.COMMON)
#武器动画完成
func _on_Weapon_attack_finished():
	_change_state(STATES.COMMON)
	craw_anim.play("step")
	is_can_attack=true


#时间等待完成
func _on_MoveTimer_timeout():
	target_update=not target_update
	set_physics_process(true)
	if(current_state==STATES.DEAD):
		queue_free()
		pass
	pass # Replace with function body.
#设置玩家
func set_player(p):
	player=p