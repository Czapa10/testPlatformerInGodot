extends Node

var coinsCounter = 0
	
func addCoin():
	coinsCounter += 1
	get_tree().get_root().get_node("World/player/Interface/IntrefaceHolder/CenterContainer/Margin/Label").set_text(str(coinsCounter) )
