extends Node2D

@onready var game:Node2D = $"/root/Game";
@export var player:Node2D;
@export var map:TileMap;

@export var min_pos_t:Vector2i = Vector2i.ZERO;
@export var max_pos_t:Vector2i = Vector2i.ZERO;
@export var water_level_ty:int = 3;


func _ready():
	game.play_sound("waves");
	game.sounds.get_node("waves").finished.connect(_on_waves_finished);
	$Player.waterLevel = $WaterLevel

func _process(_delta):
	#update wave volume
	var player_depth_t:int = map.local_to_map(map.to_local(player.position)).y - water_level_ty;
	game.set_volume("waves", get_wave_volume_db(player_depth_t));

func get_wave_volume_db(depth_t:int):
	if depth_t < 0:
		return -6;
	#return linear_to_db(clamp(1 - 0.0004 * depth_t, 0, 1)); #still too loud at depth
	return -6 - 0.008 * depth_t;

func _on_waves_finished():
	game.play_sound("waves");

func _input(event):
	if event.is_action_pressed("restart"):
		game.change_level_faded(1);
