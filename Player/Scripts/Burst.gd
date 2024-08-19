extends State

var isDoneBursting = false

# Called when the actor (FSM controller parent) enters the state
func enter():
	isDoneBursting = false
	actor.velocity = actor.burstDirection * actor.BURST_FORCE
	#print(actor.velocity)
	actor.playAnimation("accel")
	$BurstTimer.start()

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.velocity = Vector2()
	actor.enableBurstCoolDown()

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if isDoneBursting:
		return states.Idle
	return null

func handleInput(_event):
	pass

func _on_BurstTimer_timeout():
	isDoneBursting = true
