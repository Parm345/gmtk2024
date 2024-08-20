extends State

var airTime:int;


func enter():
	actor.playAnimation("jump")
	airTime = 0;
	actor.air_timer.start();
	#xVelocity = actor.velocity.x
	#if actor.useExitBurstSpeed == true:
		#xVelocity = actor.burstDirection.x * actor.MAX_BURST_FORCE
		#print('yo')

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.air_timer.stop();
	#actor.velocity.y = actor.MAX_GRAV
	#actor.useExitBurstSpeed = false
	pass;

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	print('jumping')
	actor.velocity.y += actor.GRAVITY
	actor.velocity.x *= actor.FRICTION_FACTOR_AIR

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if not actor.isAboveWater:
		return states.Idle
	return null

func handleInput(_event):
	pass

func _on_air_timer_timeout():
	airTime += 1;
	if airTime >= actor.AIR_TIME_UNTIL_DAMAGE:
		actor.takeDamage(2);
