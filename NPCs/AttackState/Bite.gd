extends State

# Called when the parent enters the state
func enter():
	#print('enter bite')
	$BiteTimer.start()

# Called when parent leaves the state, most likely not necessary 
func exit():
	#print("exit bite");
	$BiteTimer.stop()

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if actor.isDead:
		return states.Idle
	if not actor.isPreyInBiteRange:
		return states.Idle
	return null

func handleInput(_event):
	pass

func _on_bite_box_body_exited(_body: Node2D) -> void:
	if not actor == null:
		actor.isPreyInBiteRange = false

func _on_bite_timer_timeout() -> void:
	actor.bitePrey()
	if actor.isDead:
		actor.heal()
