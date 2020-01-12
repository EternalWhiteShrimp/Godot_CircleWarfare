extends "res://weapon//weapon.gd"

func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if not overlapping_bodies:
		return

	for body in overlapping_bodies:

		if not body.is_in_group("player"):
			return
		print("attacked")
		body.take_damage("craw",damage)
		
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func attack():
	$AnimationPlayer.play("attack")
	_change_state(STATES.ATTACK)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



