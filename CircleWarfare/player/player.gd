extends "res://Character/Character.gd"
signal player_dead 
export var rotation_speed=1.5

var screen_size

enum WeaponType {SWORD,KNIFE}
var currentWeapon=WeaponType.SWORD
var currentState=STATES.COMMON
var velocity = Vector2() 
var rotation_dir=0

var is_knife_skill=false
var is_sword_skill=false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	health=1
	screen_size = get_viewport_rect().size
	$knife.connect("attack_finished", self, "_on_Weapon_attack_finished")
	$sword.connect("attack_finished", self, "_on_Weapon_attack_finished")
	get_tree().call_group("enemy","set_player",self)
	pass # Replace with function body.
func get_move(delta):
	  if is_knife_skill==false:
	     #look_at_mouse(1,get_global_mouse_position(),delta)
	     look_at(get_global_mouse_position())
	  velocity=Vector2()
	  if Input.is_action_pressed('ui_right'):
          velocity.x += 1
	  if Input.is_action_pressed('ui_left'):
	      velocity.x -= 1
	  if Input.is_action_pressed("ui_down"):
		  velocity.y +=1
	  if Input.is_action_pressed("ui_up"):
		  velocity.y-=1
	  velocity = velocity.normalized() * speed
	  currentState=STATES.MOVE
func take_damage(weapon,count):
	if current_state == STATES.DEAD:
		return

	health -= count
	if health <= 0:
		health = 0
		_change_state(STATES.DEAD)
		emit_signal("died")
		return
	_change_state(STATES.STAGGER)
	emit_signal("health_changed", health)
func player_anim_control():
  if velocity.length() > 0:
      velocity = velocity.normalized() * speed
      animation_player.stop()
  else:
      animation_player.play()
	 



	#hide()
func _process(delta):
  switch_weapon()#转换武器
  skill()
  dodge(delta)
		  
   # The player's movement vector.
  if currentState!=STATES.ATTACK and is_sword_skill==false :
	  get_move(delta)
	  velocity = move_and_slide(velocity)
	  currentState=STATES.COMMON
	  #velocity = move_and_slide(velocity)
  if Input.is_action_pressed("is_attack")and currentState==STATES.COMMON :
	    _change_state(STATES.ATTACK)
  player_anim_control()#玩家动画控制

#闪避
func dodge(delta):
	if Input.is_action_pressed("shift") and Input.is_action_just_pressed('ui_right'):
	    position=position.linear_interpolate(position+Vector2(50,0),delta*50)
	if Input.is_action_pressed("shift") and Input.is_action_just_pressed('ui_left'):
	    position=position.linear_interpolate(position+Vector2(-50,0),delta*50)
	if Input.is_action_pressed("shift") and Input.is_action_just_pressed('ui_up'):
	    position=position.linear_interpolate(position+Vector2(0,-50),delta*50)
	if Input.is_action_pressed("shift") and Input.is_action_just_pressed('ui_down'):
	    position=position.linear_interpolate(position+Vector2(0,50),delta*50)
#start_attack()#开始攻击动画
func switch_weapon():
	if is_knife_skill==true or is_sword_skill==true:
		return
	if Input.is_action_just_pressed("knife"):
		currentWeapon=WeaponType.KNIFE
	if Input.is_action_just_pressed("sword"):
		currentWeapon=WeaponType.SWORD
#技能
func skill():
  if(Input.is_action_just_pressed("skill") and currentState==STATES.COMMON):
	  currentState=STATES.SKILL
	  if(currentWeapon==WeaponType.KNIFE):
		  $knife.show()
		  is_knife_skill=true
		  $knife.skill()
	  if(currentWeapon==WeaponType.SWORD):
		  is_sword_skill=true
		  $sword.show()
		  $sword.skill()   
func attack():
	  if currentWeapon==WeaponType.KNIFE:
	      $knife.show()
	      $knife.attack()
	  if currentWeapon==WeaponType.SWORD:
	      $sword.attack()
	      $sword.show()
	  currentState=STATES.ATTACK

func resurrection():
	show()
	$Sprite.show()
	currentState=STATES.COMMON
	health=max_health
#玩家死亡，播放动画
func dead():
	print("you having dead")
	$Sprite.hide()
	$Particles2D.emitting=true
	$Timer.wait_time=1
	$Timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#武器攻击完成
func _on_Weapon_attack_finished():
	  currentState=STATES.COMMON
	  
	  is_knife_skill=false
	  is_sword_skill=false
#隐藏当前角色，暂停树
func _on_Timer_timeout():
	$Timer.stop()
	hide()
	emit_signal("player_dead")
	get_tree().paused=true
	pass # Replace with function body.
#自身的动画完成
func _on_AnimationPlayer_animation_finished(name):
	if(name=="take_damage"):
		_change_state(STATES.COMMON)