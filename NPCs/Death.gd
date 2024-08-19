extends State

# Called when the actor (FSM controller parent) enters the state
func enter():
	actor.get_node("AnimatedSprite2D").set_animation("death")
	actor.get_node("AnimatedSprite2D").play()

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
	return null

func handleInput(_event):
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	if actor.get_node("AnimatedSprite2D").get_animation() == "death":
		actor.queue_free()
