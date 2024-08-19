extends State

var isTargetReached:bool = false

# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.setMovementTarget(actor.lastKnownPreyPos)

# Called when parent leaves the state, most likely not necessary 
func exit():
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	isTargetReached = actor.moveToTargetPosition(delta)
	if isTargetReached:
		actor.pointPreySight()

func changeParentState():
	if actor.isPreyInRayCast:
		return states.Hunt
	if isTargetReached and not actor.isPreyInRayCast:
		return states.Idle
	return null

func handleInput(_event):
	pass
