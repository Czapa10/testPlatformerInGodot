extends Node2D

export var maxNumberOfBalls = 5
export var maxRandomX = 100 
export var minRandomX = 0
export var maxRandomY = 0
export var minRandomY = 0

var numberOfBallsInTheWorld = 0

var ballScene = preload("res://ball.tscn")
	
func _ready():
	if maxRandomX == 0:
		maxRandomX = 1
	if maxRandomY == 0:
		maxRandomY = 1

func _on_Timer_timeout():
	if numberOfBallsInTheWorld < maxNumberOfBalls:
		var ballNode = ballScene.instance()
		ballNode.set_pos(Vector2(randi()%( maxRandomX - minRandomX) + minRandomX , randi()%( maxRandomY - minRandomY) + minRandomY ) )
		add_child(ballNode)
		numberOfBallsInTheWorld += 1
	