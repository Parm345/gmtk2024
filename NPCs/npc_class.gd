extends CharacterBody2D
class_name NPC

@export var SPECIES_NAME:String = "default"
@export var NPC_SPEED:int = 100
@export var PATH_TOLERANCE:int = 10
@export var PREY_TRACK_LEN:int = 105
@export var PRED_LEVEL:int = 10
@export var HUNGER_DAMAGE = 1
@export var MAX_HEALTH = 12
@export var BITE_DAMAGE = 12
@export var wanderLength = 40

@onready var health = MAX_HEALTH: set = takeDamage

var prey:Node2D
var lure:Node2D
var lastKnownPreyPos:Vector2 = Vector2()
var lastKnownLurePos:Vector2 = Vector2()

var isDead:bool = false

var isTargetReached:bool = false

var isPreySpotted:bool = false
var isPreyInRayCast:bool = false
var isPreyInVizCone:bool = false
var hasPreyBeenSeen:bool = false

var isHungry:bool = false
var isChasingPrey:bool = false
var isLured:bool = false

var isPreyInBiteRange:bool = false

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
		$AnimatedSprite2D.flip_h = false
		$VisionCone.scale.x = 1
		$LureVision.scale.x = 1
		$BiteBox.scale.x = 1
	else:
		$AnimatedSprite2D.flip_h = true
		$VisionCone.scale.x = -1
		$LureVision.scale.x = -1
		$BiteBox.scale.x = -1
	
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
	
func takeDamage(damageDealt):
	health -= damageDealt
	if health <= 0:
		$FSM.overrideState($FSM.states.Death)
		isDead = true

func heal():
	health = MAX_HEALTH

func bitePrey():
	prey.takeDamage(BITE_DAMAGE)

func _on_vision_cone_body_entered(body: Node2D) -> void:
	if body.is_in_group("prey") and PRED_LEVEL > 3: # pred level less than 3 is weaker than player fish
		if body.SPECIES_NAME != SPECIES_NAME: # prevent canabilism
			prey = body
			hasPreyBeenSeen = true
			isPreyInVizCone = true
			pointPreySight()

func _on_hunger_timer_timeout() -> void:
	takeDamage(HUNGER_DAMAGE)
	if health <= MAX_HEALTH/2:
		isHungry = true

func _on_lure_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("lure") and not isDead:
		if body.LURE_LEVEL >= PRED_LEVEL - 2 and body.LURE_LEVEL <= PRED_LEVEL + 2 and body.isActiveLure:
			isLured = true
			lure = body
			$FSM.overrideState($FSM.states.Lured)

func _on_lure_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("lure") and not isDead:
		if body.LURE_LEVEL >= PRED_LEVEL - 2 and body.LURE_LEVEL <= PRED_LEVEL + 2 and body.isActiveLure:
			isLured = false
			print(isLured)

func _on_bite_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("prey") and not isDead and not isLured:
		isPreyInBiteRange = true
	if body.is_in_group("lure") and not isDead and isLured:
		body.eatLure()
		takeDamage(MAX_HEALTH)
		
