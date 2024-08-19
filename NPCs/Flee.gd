extends State

var predLevel:int = 0

# Called when the actor (FSM controller parent) enters the state
func enter():
	predLevel = actor.activePredator.getPredLevel()

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
	if not actor.isPredatorSpotted:
		return states.Idle
	if predLevel <= actor.predLevel and actor.isDamaged:
		return states.FightBack
	return null

func handleInput(_event):
	pass
