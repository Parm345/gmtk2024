extends State

# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.playAnimation("swim")

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.anim.pause()

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if actor.isAboveWater:
		return states.Jump;
	if actor.velocity.length() < actor.MAX_IDLE_SPEED:
		return states.Idle
	if actor.isBursting:
		return states.Burst
	return null

func handleInput(_event):
	pass
