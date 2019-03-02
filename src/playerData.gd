extends Node

var vitality
var coins

func _ready():
	resetData()

func resetData():
	vitality = 100
	coins = 0
