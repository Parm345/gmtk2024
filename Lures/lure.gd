extends CharacterBody2D
class_name  Lure

@export var LURE_LEVEL:int = 3
@export var isActiveLure:bool = true # lure will not anything if disabled

func eatLure():
	queue_free()
