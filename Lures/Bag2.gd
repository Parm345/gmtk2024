extends Lure


func _ready():
	$AnimatedSprite2D.set_frame(randi_range(0, 2));
