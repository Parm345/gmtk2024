extends Node2D

@onready var game:Node2D = $/root/Game;
@export var player:Node2D;
@export var map:TileMap;

@export var min_pos_t:Vector2i = Vector2i.ZERO;
@export var max_pos_t:Vector2i = Vector2i.ZERO;


func _ready():
	game.play_sound("waves");
	game.sounds.get_node("waves").finished.connect(_on_waves_finished);

func _process(_delta):
	#update wave volume
	var player_depth_t:int = map.local_to_map(player.position).y;
	game.set_volume("waves", get_wave_volume_db(player_depth_t));

func get_wave_volume_db(depth_t:int):
	if depth_t < 0:
		return -6;
	#return -5 - pow(1.005, depth_t);
	return -6 - 0.001 * depth_t;

func _on_waves_finished():
	game.play_sound("waves");
