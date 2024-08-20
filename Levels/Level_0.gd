extends Node2D

@onready var game:Node2D = $"/root/Game";


func _on_start_button_pressed():
	game.change_level_faded(1);

func _on_achievements_button_pressed():
	game.change_level_faded(3);

func _ready():
	game.play_sound("ost_archaeology", false);
	game.region_ost = "ost_archaeology";
	game.ost_prob_on_timeout = 0.08;
	
	game.set_volume("waves", game.SFX_WAVES_DB_OFFSET);
	game.play_sound("waves", false);
	game.sounds.get_node("waves").finished.connect(_on_waves_finished);

func _on_waves_finished():
	game.play_sound("waves", false);
