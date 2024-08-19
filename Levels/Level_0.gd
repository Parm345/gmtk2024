extends Node2D

@onready var game:Node2D = $"/root/Game";


func _on_start_button_pressed():
	game.change_level_faded(1);

func _on_achievements_button_pressed():
	game.change_level_faded(3);

func _ready():
	game.set_volume("waves", -6);
	game.play_sound("waves");
	game.sounds.get_node("waves").finished.connect(_on_waves_finished);

func _on_waves_finished():
	game.play_sound("waves");
