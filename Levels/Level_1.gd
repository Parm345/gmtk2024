extends Node2D

@onready var game:Node2D = $"/root/Game";
@export var player:Node2D;
@export var map:TileMap;
@export var tracking_cam:Camera2D;

@export var min_pos_t:Vector2i = Vector2i.ZERO;
@export var max_pos_t:Vector2i = Vector2i.ZERO;
@export var water_level_ty:int = 3;

var has_ost_played:Dictionary = {
	"ost_deep_blue" : false,
	"ost_deep_think" : false,
	"ost_decomposition" : false,
	"ost_reminiscence" : false,
	"ost_archaeology" : false,
}


func _ready():
	game.region_ost = "";
	game.ost_prob_on_timeout = 0.08;
	
	game.play_sound("waves", false);
	game.sounds.get_node("waves").finished.connect(_on_waves_finished);
	
	player.global_position = game.saved_player_positions[game.current_level_index];
	tracking_cam.global_position = player.global_position;

func _process(_delta):
	#update wave volume
	var player_depth_t:int = map.local_to_map(map.to_local(player.position)).y - water_level_ty;
	#print(get_wave_volume_db(player_depth_t))
	game.set_volume("waves", get_wave_volume_db(player_depth_t));

func get_wave_volume_db(depth_t:int):
	if depth_t < 0:
		return game.SFX_WAVES_DB_OFFSET;
	#return linear_to_db(clamp(1 - 0.0004 * depth_t, 0, 1)); #still too loud at depth
	return game.SFX_WAVES_DB_OFFSET - 0.125 * depth_t;

func _on_waves_finished():
	game.play_sound("waves", false);

func _input(event):
	if event.is_action_pressed("restart"):
		game.saved_player_positions[1] = game.initial_player_positions[1];
		game.change_level_faded(1);
	elif event.is_action_pressed("interact"):
		for body in $Submarine.get_overlapping_bodies():
			if body == player:
				game.saved_player_positions[1] = player.global_position;
				game.change_level_faded(2);

func _on_deep_blue_body_entered(body):
	if body != player:
		return;
	if !has_ost_played["ost_deep_blue"]:
		game.play_sound("ost_deep_blue", true);
		has_ost_played["ost_deep_blue"] = true;
	game.region_ost = "ost_deep_blue";

func _on_deep_blue_body_exited(body):
	if body != player:
		return;
	game.region_ost = "";

func _on_decomposition_body_entered(body):
	if body != player:
		return;
	if !has_ost_played["ost_decomposition"]:
		game.play_sound("ost_decomposition", true);
		has_ost_played["ost_decomposition"] = true;
	game.region_ost = "ost_decomposition";

func _on_decomposition_body_exited(body):
	if body != player:
		return;
	game.region_ost = "";

func _on_deep_think_body_entered(body):
	if body != player:
		return;
	if !has_ost_played["ost_deep_think"]:
		game.play_sound("ost_deep_think", true);
		has_ost_played["ost_deep_think"] = true;
	game.region_ost = "ost_deep_think";

func _on_deep_think_body_exited(body):
	if body != player:
		return;
	game.region_ost = "";

func _on_archaeology_body_entered(body):
	if body != player:
		return;
	if !has_ost_played["ost_archaeology"]:
		game.play_sound("ost_archaeology", true);
		has_ost_played["ost_archaeology"] = true;
	game.region_ost = "ost_archaeology";

func _on_archaeology_body_exited(body):
	if body != player:
		return;
	game.region_ost = "";

func _on_reminiscence_body_entered(body):
	if body != player:
		return;
	if !has_ost_played["ost_reminiscence"]:
		game.play_sound("ost_reminiscence", true);
		has_ost_played["ost_reminiscence"] = true;
	game.region_ost = "ost_reminiscence";

func _on_reminiscence_body_exited(body):
	if body != player:
		return;
	game.region_ost = "";

func _on_submarine_body_entered(body):
	if body != player:
		return;
	$SubmarineInteract.show();

func _on_submarine_body_exited(body):
	if body != player:
		return;
	$SubmarineInteract.hide();
