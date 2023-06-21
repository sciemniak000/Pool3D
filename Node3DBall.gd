class_name Ball extends Node3D

var speed
var futurePosition
var inMovement := false

var allWalls
var wallsGettingNearer := [null, null, null]
var distancesFromWalls := [1., 1., 1.]

@onready var radiusContainer := $StaticBody3D/CollisionShape3D/CSGSphere3D
var radius

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = Vector3(0., 0., 0.)
	radius = radiusContainer.radius

func init(positioning, walls):
	position = positioning
	futurePosition = positioning
	allWalls = walls

func setMovement(newSpeed):
	speed = newSpeed
	setWallsApproaching()
	inMovement = true

func countNewPosition(delta):
	var position_delta := Vector3(delta * speed[0], delta * speed[1], delta * speed[2])
	for i in 3:
		futurePosition[i] = position[i] + position_delta[i]

func countNewPositionWithPartialSpeed(delta, partialSpeed):
	var position_delta := Vector3(delta * partialSpeed[0], delta * partialSpeed[1], delta * partialSpeed[2])
	for i in 3:
		futurePosition[i] = position[i] + position_delta[i]

func countWallDistances():
	for i in 3:
		distancesFromWalls[i] = countFutureDistanceToWall(wallsGettingNearer[i])

func countFutureDistanceToWall(wall):
	return wall.normalVector.dot(futurePosition - wall.nominalPoint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func isMoving():
	return inMovement

func processCollisions():
	for i in 3:
		if(distancesFromWalls[i] < 0):
			speed[i] = -speed[i]
			futurePosition[i] = position[i]
			setWallsApproaching()

func setWallsApproaching():
	if(speed[0] >= 0):
		wallsGettingNearer[0] = allWalls[1]
	else:
		wallsGettingNearer[0] = allWalls[0]
	
	if(speed[1] >= 0):
		wallsGettingNearer[1] = allWalls[3]
	else:
		wallsGettingNearer[1] = allWalls[2]
	
	if(speed[2] >= 0):
		wallsGettingNearer[2] = allWalls[5]
	else:
		wallsGettingNearer[2] = allWalls[4]

func acceptThePosition():
	for i in 3:
		position[i] = futurePosition[i]
