extends "res://weapon//weapon.gd"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"




func _physics_process(delta):

	var overlapping_bodies = get_overlapping_bodies()
	if not overlapping_bodies:
		return

	for body in overlapping_bodies:

		if not body.is_in_group("enemy"):
			return
		
		body.take_damage("knife",damage)
		
	#set_physics_process(false)



func attack():
	$AnimationPlayer.play("attack")
	$Line2D.start_draw()
	_change_state(STATES.ATTACK)
func skill():
	$AnimationPlayer.play("skill")
	$Line2D.start_draw()
	_change_state(STATES.SKILL)
func _on_AnimationPlayer_animation_finished( name ):
	if name == "attack" or name=="skill":
		$Line2D.stop_draw()
		set_physics_process(false)
		emit_signal("attack_finished")
		$AnimationPlayer.play("step")

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
