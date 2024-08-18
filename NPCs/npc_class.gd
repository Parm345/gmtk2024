extends CharacterBody2D
class_name NPC

@export var NPC_SPEED:int = 100
@export var PATH_TOLERANCE:int = 10
@export var PREY_TRACK_LEN:int = 105

var player:Node2D
var lastKnownPreyPos:Vector2 = Vector2()

var isPreySpotted:bool = false
var isPreyInRayCast:bool = false
var isPreyLayerInVizCone:bool = false
var hasPreyBeenSeen:bool = false

func _ready() -> void:
	$NavigationAgent2D.path_desired_distance = PATH_TOLERANCE
	$NavigationAgent2D.target_desired_distance = PATH_TOLERANCE

func _physics_process(delta):
	pointPreySight()

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
	
	return false

func pointPreySight() -> void:
	if hasPreyBeenSeen:
		var preyDirection:Vector2 = player.global_position - global_position
		preyDirection = preyDirection.normalized()*PREY_TRACK_LEN
		$PreySight.target_position = preyDirection
	
	if $PreySight.is_colliding():
			var collisonObject:Node2D = $PreySight.get_collider()
			if collisonObject != null: # somehow an error
				if collisonObject.is_in_group("player"):
					isPreyInRayCast = true
					return
	isPreyInRayCast = false

