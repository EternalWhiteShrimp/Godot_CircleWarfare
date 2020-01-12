extends KinematicBody2D

signal health_changed
signal died



onready var animation_player = $AnimationPlayer

enum STATES {COMMON, MOVE, ATTACK, STAGGER,  DEAD,SKILL}
var current_state = null
var previous_state = null

var speed = 200
var look_direction = Vector2(1, 0)
var move_direction = Vector2()
var input_direction = Vector2()


export var max_health = 1
var health


func _ready():
	health = max_health
	# Weapon setup
	_change_state(STATES.COMMON)


func _on_Weapon_attack_finished():
	_change_state(STATES.COMMON)


#转换状态，攻击状态另算
func _change_state(new_state):
	previous_state = current_state
	current_state = new_state
	# initialize/enter the state
	match new_state:
		STATES.COMMON:
			animation_player.play("step")
		STATES.ATTACK:
			attack()
		STATES.SKILL:
			skill()
		STATES.STAGGER:
			animation_player.play("take_damage")
		STATES.DEAD:
			dead()
func dead():
	pass
func attack():
	pass
func skill():
	pass
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


func _on_AnimationPlayer_animation_finished( name ):
	if name == "take_damage":
		_change_state(STATES.COMMON)
