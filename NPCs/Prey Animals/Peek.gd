extends State

var next_state

# Called when the actor (FSM controller parent) enters the state
func enter():
	next_state = null;
	actor.anim.play("peek");

# Called when parent leaves the state, most likely not necessary 
func exit():
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	return next_state

func handleInput(_event):
	pass

func _on_animated_sprite_2d_animation_finished():
	next_state = states.Bask;
