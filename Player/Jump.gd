extends State

var xVelocity:int = 0

func enter():
	actor.playAnimation("jump") 
	xVelocity = actor.velocity.x
	if actor.useExitBurstSpeed == true:
		xVelocity = actor.burstDirection.x * actor.MAX_BURST_FORCE
		print('yo')

# Called when parent leaves the state, most likely not necessary 
func exit():
	#actor.velocity.y = actor.MAX_GRAV
	actor.useExitBurstSpeed = false

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	actor.velocity.y += actor.GRAVITY
	actor.velocity.x = xVelocity

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if not actor.isAboveWater:
		return states.Idle
	return null

func handleInput(_event):
	pass

