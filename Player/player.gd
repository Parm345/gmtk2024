extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ACCL = 50
export var BURST_FORCE = 1000
export var MAX_SPEED = 350

var isBurstEnabled = true
var isBursting = false
var burstDirection:Vector2 = Vector2()

var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	$FSM.setState($FSM.states.Idle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouseDirection:Vector2 = get_viewport().get_mouse_position() - global_position
	set_rotation(mouseDirection.angle())
	
	if mouseDirection.x > 0:
		$Sprite.flip_v = false
	if mouseDirection.x < 0:
		$Sprite.flip_v = true

func _physics_process(delta):
	var movementDirection:Vector2 = Vector2()
	
	if !isBursting:
		if Input.is_action_pressed("ui_left"):
			movementDirection.x -= 1;
		if Input.is_action_pressed("ui_right"):
			movementDirection.x += 1;
		if Input.is_action_pressed("ui_up"):
			movementDirection.y -= 1;
		if Input.is_action_pressed("ui_down"):
			movementDirection.y += 1;
	velocity += movementDirection.normalized()*ACCL
	
	if $FSM.curState != $FSM.states.Burst:
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _input(event):
	if event.is_action_released("ui_left") or event.is_action_released("ui_right"):
		velocity.x = 0
	if event.is_action_released("ui_up") or event.is_action_released("ui_down"):
		velocity.y = 0

	if event.is_action_pressed("burst") and isBurstEnabled:
		burstDirection = (event.position - global_position).normalized()
		isBursting = true
		isBurstEnabled = false

func enableBurstCoolDown():
	$BurstCoolDown.start()
	isBursting = false
#	burstTargetDirection = Vector2()

func _on_BurstCoolDown_timeout():
	isBurstEnabled = true
