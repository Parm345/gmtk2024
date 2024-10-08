extends State

# Called when the parent enters the state
func enter():
	pass 

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
	if actor.isDead:
		return null
	if actor.isPreyInBiteRange and (actor.isHunting or actor.isLured):
		return states.Bite
	return null

func handleInput(_event):
	pass

		
