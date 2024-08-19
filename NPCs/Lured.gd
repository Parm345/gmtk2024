extends State

var isTargetReached:bool = false
var lurePos:Vector2 = Vector2()

# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.isChasingPrey = true
	lurePos = actor.lure.global_position

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.lastKnownLurePos = lurePos
	actor.isChasingPrey = false

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	if actor.isLured:
		lurePos = actor.lure.global_position
	actor.setMovementTarget(lurePos)
	isTargetReached = actor.moveToTargetPosition(delta)
	
# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if not actor.isLured and isTargetReached:
		return states.Idle
	return null

func handleInput(event):
	pass
