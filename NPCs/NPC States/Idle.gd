extends State

var isIdling = true

# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.velocity = Vector2()
	$IdleTimeOut.start()
	isIdling = true

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
	if not isIdling:
		return states.Wander
	return null

func handleInput(event):
	pass


func _on_IdleTimeOut_timeout():
	isIdling = false


func _on_VisionCone_body_entered(body):
	pass # Replace with function body.
