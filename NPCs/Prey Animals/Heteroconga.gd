extends Node2D

@onready var anim:AnimatedSprite2D = $AnimatedSprite2D;
var is_scared:bool = false;

func _ready():
	$FSM.setState($FSM.states.Bask)

func _on_area_2d_body_entered(_body):
	is_scared = true;
	$CopeTimer.start();

func _on_cope_timer_timeout():
	is_scared = false;
