extends CSGBox3D

var normalVector = Vector3(0.0, 0.0, 1.0)
var nominalPoint = Vector3(-49.0, 0., -48.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Wall5:")
	print("Position: " + str(position) + "; normal vector: " + str(normalVector) + "; nominalPoint: " + str(nominalPoint))

func getDebugId():
	return "Wall5"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
