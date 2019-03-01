extends Area2D

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_name() == "player":
			addCoin()
			queue_free()

func addCoin():
	playerData.coins += 1
	get_tree().get_root().get_node("World/player/Interface/IntrefaceHolder/CenterContainer/Margin/Label").set_text(str(playerData.coins) )