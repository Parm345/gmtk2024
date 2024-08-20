extends CharacterBody2D

signal moved;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var SPECIES_NAME = "Player"
@export var ACCL = 50
@export var MAX_BURST_FORCE = 100
@export var ACCL_DIST_RATIO = 0.75;
@export var MAX_ACCL_DIST = 800
@export var MAX_SWIM_SPEED = 280
@export var MAX_BURST_SPEED = 480;
@export var MAX_IDLE_SPEED = 8;
@export var MAX_GRAV = 100
@export var GRAVITY = 6
@export var BITE_STRENGTH = 10
@export var FRICTION_FACTOR_WATER = 0.98
@export var FRICTION_FACTOR_AIR = 0.998
@export var FRICTION_FACTOR_BURST = 0.94;
@export var FRICTION_FACTOR_BRAKE = 0.6
@export var MAX_LENSQ_TO_MOUSE_FOR_BRAKE = 64 #exclusive
@export var MIN_LENSQ_TO_MOUSE_FOR_ACCL = 64 #inclusive
@export var MIN_LENSQ_TO_MOUSE_FOR_ROTATION = 0; #inclusive
@export var OSC_DIR_DAMPENING = 0.05
@export var AIR_TIME_UNTIL_DAMAGE = 6;
@export var health = 12

var mouseDirection:Vector2;
var lensqToMouse:float;
var isDead = false

var isBurstEnabled = true
var isBursting = false
var burstDirection:Vector2;
var burstStartPos:Vector2;
var burstDistance:float;
var burstDistanceAccl:float;
var burstDistanceTotal:float;

var isAllowedToBite:bool = false
var preyNodesInRange = []

var isLureInRange:bool = false
var isLureEquiped:bool = false
var nearbyLure:Lure = null
var equipedLure:Lure = null

var prevAnim:String = ""

var waterLevel:Marker2D = null
var isAboveWater:bool = false
var useExitBurstSpeed = false

@onready var anim:AnimatedSprite2D = $AnimatedSprite2D;
@onready var air_timer:Timer = $AirTimer;

# Called when the node enters the scene tree for the first time.
func _ready():
	$FSM.setState($FSM.states.Idle)
	#print(get_world_2d().navigation_map)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if !isBursting and lensqToMouse >= MIN_LENSQ_TO_MOUSE_FOR_ROTATION:
		set_rotation(mouseDirection.angle()) # make sure rotation constant when bursting
	
	if equipedLure != null:
		equipedLure.global_position = $LureEquipSpot.global_position
		equipedLure.global_rotation = $LureEquipSpot.global_rotation
	
	if mouseDirection.x > 0:
		$AnimatedSprite2D.flip_v = false
	elif mouseDirection.x < 0:
		$AnimatedSprite2D.flip_v = true

func _physics_process(_delta):
	#burstDistance
	if isBursting:
		burstDistance = (global_position - burstStartPos).length()
	
	#friction
	velocity *= FRICTION_FACTOR_WATER;
	
	mouseDirection = get_global_mouse_position() - global_position;
	lensqToMouse = mouseDirection.length_squared();
	if !isBursting and Input.is_action_pressed("move") and not isAboveWater:
		if lensqToMouse >= MIN_LENSQ_TO_MOUSE_FOR_ACCL:
			var mouseDirectionNorm:Vector2 = mouseDirection.normalized();
			var oscillationDirNorm:Vector2 = Vector2(-mouseDirectionNorm.y, mouseDirectionNorm.x);
			var velocityOscillationComp:Vector2 = velocity.dot(oscillationDirNorm) * oscillationDirNorm;
			velocity += mouseDirectionNorm * ACCL - velocityOscillationComp * OSC_DIR_DAMPENING;
		elif lensqToMouse < MAX_LENSQ_TO_MOUSE_FOR_BRAKE:
			velocity *= FRICTION_FACTOR_BRAKE;
	
	pass
	
	if waterLevel != null:
		if global_position.y < waterLevel.global_position.y:
			isAboveWater = true
		else:
			isAboveWater = false
	
	#clamp speed
	var speed:float = velocity.length();
	if $FSM.curState != $FSM.states.Burst and $FSM.curState != $FSM.states.Jump:
		if speed > MAX_SWIM_SPEED:
			velocity *= MAX_SWIM_SPEED/speed;
		#if not isAboveWater:
			#velocity.y = clamp(velocity.y, -MAX_SWIM_SPEED, MAX_SWIM_SPEED)
		#else:
			#velocity.y = clamp(velocity.y, -MAX_GRAV, MAX_GRAV)
	else:
		if speed > MAX_BURST_SPEED:
			velocity *= MAX_BURST_SPEED/speed;
			
	if velocity.length_squared() > 0:
		moved.emit();
	move_and_slide()

func _input(event):
	if !isBursting:
		if event.is_action_pressed("bite"):
			prevAnim = $AnimatedSprite2D.animation
			for prey in preyNodesInRange:
				if prey.PRED_LEVEL > 5:
					playAnimation("bite2") 
			if $AnimatedSprite2D.animation != "bite2":
				playAnimation("bite1")
			
			# called during idle time cuz godot doesn't support looping through arrays if you delete 
			# something from it
			call_deferred("bite")

#put burst here so button presses don't trigger it
func _unhandled_input(event):
	if event.is_action_pressed("burst") and isBurstEnabled and not isAboveWater:
		burstDirection = mouseDirection.normalized()
		isBursting = true
		burstStartPos = global_position;
		burstDistance = 0
		burstDistanceAccl = min(mouseDirection.length() * ACCL_DIST_RATIO, MAX_ACCL_DIST);
		burstDistanceTotal = mouseDirection.length();
		isBurstEnabled = false

func playAnimation(animationName: String) -> void:
	$AnimatedSprite2D.play(animationName)
	if animationName == "bite2":
		$AnimatedSprite2D.offset.y = 8
	else:
		$AnimatedSprite2D.offset.y = 0

func enableBurstCoolDown():
	$BurstCoolDown.start()
	isBursting = false
#	burstTargetDirection = Vector2()

func _on_BurstCoolDown_timeout():
	isBurstEnabled = true

func takeDamage(damageDealt):
	health -= damageDealt
	$AnimationPlayer.play("hurt");
	if health <= 0:
		$FSM.overrideState($FSM.states.Death)
		isDead = true

func bite():
	if not isLureEquiped:
		for prey in preyNodesInRange:
			prey.takeDamage(BITE_STRENGTH)
		if isLureInRange:
			equipedLure = nearbyLure
			isLureEquiped = true
			return
	if isLureEquiped:
		equipedLure = null
		isLureEquiped = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("npc_prey") and body != self:
		preyNodesInRange.append(body)
	if body.is_in_group("lure"):
		isLureInRange = true
		nearbyLure = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("npc_prey") and body != self:
		preyNodesInRange.erase(body)
	if body.is_in_group("lure"):
		isLureInRange = false
		nearbyLure = null
