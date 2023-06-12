extends StaticBody3D

var speed

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 0
	
	var timer := Timer.new()
	add_child(timer)
	
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.connect("timeout", enableMovement)
	timer.start()

func enableMovement():
	speed = 0.05


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(Vector3(0., 0., -speed))
