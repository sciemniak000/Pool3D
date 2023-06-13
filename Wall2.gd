extends CSGBox3D

var normalVector = Vector3(0.0, 0.0, -1.0)
var nominalPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	nominalPoint = position + 0.5 * normalVector


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
