extends CSGBox3D

var normalVector = Vector3(1.0, 0.0, 0.0)
var nominalPoint = Vector3(-97.5, 0., 0.)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Wall1:")
	print("Position: " + str(position) + "; normal vector: " + str(normalVector) + "; nominalPoint: " + str(nominalPoint))

func getDebugId():
	return "Wall1"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
