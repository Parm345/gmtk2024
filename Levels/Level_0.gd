extends Node2D

@onready var game:Node2D = $"/root/Game";


func _on_start_button_pressed():
	game.change_level_faded(1);

func _on_achievements_button_pressed():
	game.change_level_faded(3);
