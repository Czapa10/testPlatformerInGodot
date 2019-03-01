#worldComplete.gd
extends Area2D

export(String, FILE, "*.tscn") var nextWorld

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_name() == "player":
			get_tree().change_scene(nextWorld)
			
