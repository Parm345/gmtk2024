extends Node2D

signal level_changed;

const TRACKING_CAM_LEAD_RATIO:float = 2; #target = pos + ratio * (track_pos - pos)
const TRACKING_CAM_SLACK_RATIO:float = 0.9; #0.25; #ratio applied to slack (tracking movement along the non-trigger axis)
const TRACKING_CAM_TRANSITION_TIME:float = 1.28;
const LEVEL_COUNT:int = 4;
const VIEWPORT_SIZE:Vector2i = Vector2i(1280, 720);
const TILE_WIDTH:int = 16;

var levels = [];
var current_level_index:int = 0;
var current_level:Node2D;
var paused:bool = false;

# NPC navigation stuff
var nav_map

@onready var pause_menu:Control = $"GUI/PauseMenu";
@onready var fader:AnimationPlayer = $AnimationPlayer;
@onready var sounds:Node2D = $Sounds;
@onready var back_button:TextureButton = $"GUI/Buttons/HBoxContainer/Back";
@onready var pause_button:TextureButton = $"GUI/Buttons/HBoxContainer/Pause";


# Called when the node enters the scene tree for the first time.
func _ready():
	#levels
	for i in range(LEVEL_COUNT):
		levels.append(load("res://Levels/Level_"+str(i)+".tscn"));
	#change_level_faded(current_level_index);
	add_level(current_level_index);

#defer this until previous level has been freed
func add_level(n):
	var level:Node2D = levels[n].instantiate();
	add_child(level);
	current_level = level;
	
	emit_signal("level_changed");

#update current level and current level index
func change_level(n):
	if (n >= LEVEL_COUNT):
		return;
	if current_level != null:
		current_level.queue_free();
	
	if n == 3:
		back_button.show();
		back_button.disabled = false;
	else:
		back_button.hide();
		back_button.disabled = true;
	
	call_deferred("add_level", n);
	current_level_index = n;
	
func change_level_faded(n):
	if n >= LEVEL_COUNT:
		return;
	current_level_index = n;
	
	#fade out
	fader.play("fade_in_fish");

func setupNavServer():
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in_fish":
		change_level(current_level_index);
		fader.play("fade_out_fish");

func play_sound(s:String):
	var audio_player:AudioStreamPlayer2D = sounds.get_node(s);
	audio_player.play();

func set_volume(s:String, v_db:float):
	var audio_player:AudioStreamPlayer2D = sounds.get_node(s);
	audio_player.volume_db = v_db;

func _input(event):
	if event.is_action_pressed("escape"):
		toggle_pause_menu();

func toggle_pause_menu():
	if paused:
		pause_menu.hide();
		Engine.time_scale = 1;
	else:
		pause_menu.show();
		Engine.time_scale = 0;
	
	paused = !paused;


func _on_resume_pressed():
	toggle_pause_menu();

func _on_home_pressed():
	change_level_faded(0);
	toggle_pause_menu();

func _on_quit_pressed():
	get_tree().quit();

func _on_back_pressed():
	change_level_faded(0);

func _on_pause_pressed():
	toggle_pause_menu();
