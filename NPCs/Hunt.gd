extends State

var isTargetReached:bool = false
var preyPos:Vector2 = Vector2()

# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.isHunting = true

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.lastKnownPreyPos = preyPos
	actor.isChasingPrey = false

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	preyPos = actor.prey.global_position
	actor.setMovementTarget(preyPos)
	isTargetReached = actor.moveToTargetPosition(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if not actor.isPreyInRayCast:
		return states.Search
	return null

func handleInput(event):
	pass
