extends "res://weapon//weapon.gd"


func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if not overlapping_bodies:
		return
	for body in overlapping_bodies:

		if not body.is_in_group("enemy"):
			return
		print(body.name)
		body.take_damage("sword",damage)
	set_physics_process(false)

func skill():
	$AnimationPlayer.play("skill")
	_change_state(STATES.SKILL)



