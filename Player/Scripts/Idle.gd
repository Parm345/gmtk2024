extends State

var isBursting = false

# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.velocity = Vector2()
	actor.anim.speed_scale = 0.5;
	actor.playAnimation("swim")

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.anim.speed_scale = 1;
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if actor.velocity.length_squared() > 0:
		return states.Swim
	if actor.isBursting:
		return states.Burst
	return null

func handleInput(event):
	pass
