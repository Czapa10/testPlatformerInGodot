extends Area2D

signal coinWasPickedUp

func _ready():
	set_fixed_process(true)
	self.connect("coinWasPickedUp", get_parent(), "addCoin")

func _fixed_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_name() == "player":
			emit_signal("coinWasPickedUp")
			queue_free()
