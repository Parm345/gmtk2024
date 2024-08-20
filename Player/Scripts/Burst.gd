extends State


# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.playAnimation("accel")

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.enableBurstCoolDown()

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	
	if actor.burstDistance < actor.burstDistanceAccl:
		actor.velocity += actor.burstDirection * actor.MAX_BURST_FORCE * (actor.burstDistanceAccl / actor.MAX_ACCL_DIST);
	else:
		#var friction_factor:float = 1 - actor.burstDistance / 10 / actor.burstDistanceTotal;
		actor.velocity *= actor.FRICTION_FACTOR_BURST;

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if actor.isAboveWater:
		return states.Jump;
	if actor.burstDistance >= actor.burstDistanceAccl:
		var speed:float = actor.velocity.length();
		if speed < actor.MAX_IDLE_SPEED:
			return states.Idle
		elif speed < actor.MAX_SWIM_SPEED:
			return states.Swim;
	return null

func handleInput(_event):
	pass
