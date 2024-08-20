extends Node2D

@onready var game:Node2D = $"/root/Game";
@export var player:Node2D;
@export var map:TileMap;
@export var tracking_cam:Camera2D;

@export var min_pos_t:Vector2 = Vector2.ZERO;
@export var max_pos_t:Vector2 = Vector2.ZERO;


func _ready():
	game.region_ost = "ost_deep_think";
	game.ost_prob_on_timeout = 0.3;
	
	player.global_position = game.saved_player_positions[game.current_level_index];
	tracking_cam.global_position = player.global_position.clamp(tracking_cam.min_pos, tracking_cam.max_pos);

func _on_ocean_body_entered(body):
	if body != player:
		return;
	$OceanInteract.show();

func _on_ocean_body_exited(body):
	if body != player:
		return;
	$OceanInteract.hide();

func _input(event):
	if event.is_action_pressed("restart"):
		game.saved_player_positions[2] = game.initial_player_positions[2];
		game.change_level_faded(2);
	elif event.is_action_pressed("interact"):
		for body in $Ocean.get_overlapping_bodies():
			if body == player:
				game.saved_player_positions[2] = player.global_position;
				game.change_level_faded(1);
