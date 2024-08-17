extends State

var actorSpeed = 0

# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.velocity = Vector2()
	actorSpeed = actor.SPEED
	pass

# Called when parent leaves the state, most likely not necessary 
func exit():
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(_delta):
	if Input.is_action_pressed("ui_right"):
		actor.velocity.x += actor.SPEED	
	if Input.is_action_pressed("ui_left"):
		actor.velocity.x -= actor.SPEED
	if Input.is_action_pressed("ui_up"):
		actor.velocity.y -= actor.SPEED
	if Input.is_action_pressed("ui_right"):
		actor.velocity.y += actor.SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	return null

func handleInput(event):
	pass
