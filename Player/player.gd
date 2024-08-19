extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var SPECIES_NAME = "Player"
@export var ACCL = 50
@export var BURST_FORCE = 1000
@export var MAX_SPEED = 350
@export var BITE_STRENGTH = 10
@export var health = 12

var isDead = false

var isBurstEnabled = true
var isBursting = false
var burstDirection:Vector2 = Vector2()

var isAllowedToBite:bool = false
var preyNodesInRange = []

var isLureInRange:bool = false
var isLureEquiped:bool = false
var nearbyLure:Lure = null
var equipedLure:Lure = null

var prevAnim:String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$FSM.setState($FSM.states.Idle)
	print(get_world_2d().navigation_map)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouseDirection:Vector2 = get_global_mouse_position() - global_position
	if not isBursting:
		set_rotation(mouseDirection.angle()) # make sure to fix whe bursting
	
	if equipedLure != null:
		equipedLure.global_position = $LureEquipSpot.global_position
		equipedLure.global_rotation = $LureEquipSpot.global_rotation
	
	if mouseDirection.x > 0:
		$AnimatedSprite2D.flip_v = false
	elif mouseDirection.x < 0:
		$AnimatedSprite2D.flip_v = true

func _physics_process(delta):
	var movementDirection:Vector2 = Vector2()
	
	if !isBursting:
		if Input.is_action_pressed("left"):
			movementDirection.x -= 1;
		if Input.is_action_pressed("right"):
			movementDirection.x += 1;
		if Input.is_action_pressed("up"):
			movementDirection.y -= 1;
		if Input.is_action_pressed("down"):
			movementDirection.y += 1;
	velocity += movementDirection.normalized()*ACCL
	
	if $FSM.curState != $FSM.states.Burst:
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	
	move_and_slide()

func _input(event):
	if !isBursting:
		if event.is_action_released("left") or event.is_action_released("right"):
			velocity.x = 0
		if event.is_action_released("up") or event.is_action_released("down"):
			velocity.y = 0
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

	if event.is_action_pressed("burst") and isBurstEnabled:
		burstDirection = (event.position - global_position).normalized()
		isBursting = true
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
