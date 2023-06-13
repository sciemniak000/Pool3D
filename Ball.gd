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
	speed = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var position_delta := Vector3(0., delta * (-speed), 0.)
	var new_position := position + position_delta
	var Wall := $"../Room/Wall3"
	var distance :float = Wall.normalVector.dot(new_position - Wall.nominalPoint)
	print(distance)
	if(distance >= 0):
		translate(position_delta)
