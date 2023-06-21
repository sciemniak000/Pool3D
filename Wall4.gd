extends CSGBox3D

var normalVector = Vector3(0.0, -1.0, 0.0)
var nominalPoint = Vector3(-49., 48.5, 0.)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Wall4:")
	print("Position: " + str(position) + "; normal vector: " + str(normalVector) + "; nominalPoint: " + str(nominalPoint))

func getDebugId():
	return "Wall4"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
