extends CharacterBody2D
class_name NPC

@export var SPECIES_NAME:String = "default"
@export var NPC_SPEED:int = 100
@export var PATH_TOLERANCE:int = 10
@export var PREY_TRACK_LEN:int = 105
@export var PRED_LEVEL:int = 10
@export var health = 12
@export var wanderLength = 40

var prey:Node2D
var lastKnownPreyPos:Vector2 = Vector2()

var isTargetReached:bool = false

var isPreySpotted:bool = false
var isPreyInRayCast:bool = false
var isPreyInVizCone:bool = false
var hasPreyBeenSeen:bool = false

var isHungry:bool = true
var isHunting:bool = true
var isChasingPrey:bool = false

func _ready() -> void:
	$NavigationAgent2D.path_desired_distance = PATH_TOLERANCE
	$NavigationAgent2D.target_desired_distance = PATH_TOLERANCE
	$FSM.setState($FSM.states.Wander)

func _physics_process(delta):
	pointPreySight()

func setMovementTarget(target: Vector2) -> void:
	$NavigationAgent2D.target_position = target

func setRelativeMovementTarget(target: Vector2) -> void:
	$NavigationAgent2D.target_position = global_position + target

# execute in physics process and returns true if movement is complete 
func moveToTargetPosition(delta:float) -> bool:
	if $NavigationAgent2D.is_navigation_finished():
		return true
	
	var curPos:Vector2 = global_position
	var goalPos:Vector2 = $NavigationAgent2D.get_next_path_position()
	var velocityVector:Vector2 = goalPos - curPos
	
	velocityVector = velocityVector.normalized()
	velocityVector = velocityVector*NPC_SPEED
	
	velocity = velocityVector
	
	if velocity.x > 0:
		$VisionCone.scale.x = 1
	else:
		$VisionCone.scale.x = -1
	
	move_and_slide()
	
	return false

func pointPreySight() -> void:
	if hasPreyBeenSeen:
		var preyDirection:Vector2 = prey.global_position - global_position
		preyDirection = preyDirection.normalized()*PREY_TRACK_LEN
		$PreySight.target_position = preyDirection
	
	if $PreySight.is_colliding():
			var collisonObject:Node2D = $PreySight.get_collider()
			if collisonObject != null: # somehow an error
				if collisonObject.is_in_group("prey"):
					isPreyInRayCast = true
					return
	isPreyInRayCast = false
	
func takeDmamge(damageDealt):
	health -= damageDealt
	if health <= 0:
		$FSM.overrideState($FSM.states.Death)

func _on_vision_cone_body_entered(body: Node2D) -> void:
	if body.is_in_group("prey"):
		if body.SPECIES_NAME != SPECIES_NAME: # prevent canabilism
			prey = body
			hasPreyBeenSeen = true
			isPreyInVizCone = true
			pointPreySight()
