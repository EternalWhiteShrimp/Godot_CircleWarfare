extends Area2D
signal attack_finished
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation_player = $AnimationPlayer

enum STATES {COMMON, ATTACK,SKILL}
var current_state = STATES.COMMON

export(int) var damage = 1

func _ready():
	set_physics_process(false)


func _physics_process(delta):
	pass



func _change_state(new_state):
	current_state = new_state

	# Initialize the new state
	match new_state:
		STATES.ATTACK:
			set_physics_process(true)
		STATES.SKILL:
			set_physics_process(true)
		STATES.IDLE:
			set_physics_process(false)


func attack():
	$AnimationPlayer.play("attack")
	_change_state(STATES.ATTACK)
func skill():
	$AnimationPlayer.play("skill")
	_change_state(STATES.SKILL)
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_AnimationPlayer_animation_finished( name ):
	if name == "attack" or name=="skill":
		emit_signal("attack_finished")
		hide()