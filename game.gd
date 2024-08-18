extends Node2D

@onready var current_level:Node2D;
@onready var fader:AnimationPlayer = $AnimationPlayer;


signal level_changed;
var levels = [];
var next_level_index:int;

# NPC navigation stuff
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	#levels
	for i in range(GV.LEVEL_COUNT):
		levels.append(load("res://Levels/Level_"+str(i+1)+".tscn"));
	add_level(GV.current_level_index);

#defer this until previous level has been freed
func add_level(n):
	var level:Node2D = levels[n].instantiate();
	add_child(level);
	current_level = level;
	
	#fade in music
	if current_level.has_node("BGM"):
		var bgm = current_level.get_node("BGM");
		bgm.fade_in();
		bgm.play();
	
	emit_signal("level_changed");

#update current level and current level index
func change_level(n):
	if (n >= GV.LEVEL_COUNT):
		return;
	current_level.queue_free();
	GV.current_level_score = 0;
	
	call_deferred("add_level", n);
	GV.current_level_index = n;
	
func change_level_faded(n):
	if (n >= GV.LEVEL_COUNT):
		return;
	next_level_index = n;
	
	#fade out
	fader.play("fade_in_black");
	if current_level.has_node("BGM"):
		current_level.get_node("BGM").fade_out();

func setupNavServer():
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in_black":
		change_level(next_level_index);
		fader.play("fade_out_black");
