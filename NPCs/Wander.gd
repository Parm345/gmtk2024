extends State

var frontRayCast:RayCast2D
var frontRayCast2:RayCast2D
var rearRayCast:RayCast2D
var rearRayCast2:RayCast2D

var isTargetReached = false
var isMovingForward = true

# Called when the actor (FSM controller parent) enters the state
func enter():
	frontRayCast = actor.get_node("FrontVision")
	frontRayCast2 = actor.get_node("FrontVision2")
	rearRayCast = actor.get_node("RearVision")
	rearRayCast2 = actor.get_node("RearVision2")
	
	if (frontRayCast.is_colliding() or frontRayCast2.is_colliding()) and isMovingForward:
		isMovingForward = false
		actor.setRelativeMovementTarget(Vector2(-actor.wanderLength, 0))
	if (rearRayCast.is_colliding() or rearRayCast2.is_colliding()) and !isMovingForward:
		isMovingForward = true
		actor.setRelativeMovementTarget(Vector2(actor.wanderLength, 0))
	
	if isMovingForward:
		actor.setRelativeMovementTarget(Vector2(actor.wanderLength, 0))
	else:
		actor.setRelativeMovementTarget(Vector2(-actor.wanderLength, 0))

# Called when parent leaves the state, most likely not necessary 
func exit():
	isTargetReached = false

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	if (frontRayCast.is_colliding() or frontRayCast2.is_colliding()) and isMovingForward:
		isMovingForward = false
		actor.setRelativeMovementTarget(Vector2(0, 0))
	if (rearRayCast.is_colliding() or rearRayCast2.is_colliding()) and !isMovingForward:
		isMovingForward = true
		actor.setRelativeMovementTarget(Vector2(0, 0))
	isTargetReached = actor.moveToTargetPosition(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(_delta):
	pass

func changeParentState():
	if actor.isPreyInRayCast and actor.isHungry:
		return states.Hunt
	if isTargetReached:
		return states.Idle
	return null

func handleInput(event):
	pass


func _on_VisionCone_body_entered(body):
	pass # Replace with function body.
