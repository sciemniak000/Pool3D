class_name Ball extends Node3D

var speed
var futurePosition
var inMovement := false

var allWalls
var wallsGettingNearer := [null, null, null]
var distancesFromWalls := [1., 1., 1.]

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = Vector3(0., 0., 0.)

func init(positioning, walls):
	position = positioning
	futurePosition = positioning
	allWalls = walls

func setMovement(newSpeed):
	speed = newSpeed
	print("Speed set to: " + str(speed))
	setWallsApproaching()
	inMovement = true

func countNewPosition(delta):
	var position_delta := Vector3(delta * speed[0], delta * speed[1], delta * speed[2])
	print("Calculated position delta to: " + str(position_delta) + " from delta: " + str(delta)
	+ " and speed: " + str(speed))
	for i in 3:
		futurePosition[i] = position[i] + position_delta[i]
	print("Future position set to: " + str(futurePosition))

func countWallDistances():
	for i in 3:
		distancesFromWalls[i] = countFutureDistanceToWall(wallsGettingNearer[i])

func countFutureDistanceToWall(wall):
	return wall.normalVector.dot(futurePosition - wall.nominalPoint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("new position: " + str(futurePosition))
	print(distancesFromWalls)

func isMoving():
	return inMovement

func processCollisions():
	for i in 3:
		if(distancesFromWalls[i] < 0):
			print("should collide with wall: " + wallsGettingNearer[i].getDebugId() + "; old speed: " + str(speed))
			speed[i] = -speed[i]
			print("new speed: " + str(speed))
			futurePosition[i] = position[i]
			setWallsApproaching()

func setWallsApproaching():
	if(speed[0] >= 0):
		wallsGettingNearer[0] = allWalls[1]
		print("Setting first awaiting wall to " + allWalls[0].getDebugId())
	else:
		wallsGettingNearer[0] = allWalls[0]
		print("Setting first awaiting wall to " + allWalls[1].getDebugId())
	
	if(speed[1] >= 0):
		wallsGettingNearer[1] = allWalls[3]
		print("Setting second awaiting wall to " + allWalls[3].getDebugId())
	else:
		wallsGettingNearer[1] = allWalls[2]
		print("Setting second awaiting wall to " + allWalls[2].getDebugId())
	
	if(speed[2] >= 0):
		wallsGettingNearer[2] = allWalls[5]
		print("Setting third awaiting wall to " + allWalls[5].getDebugId())
	else:
		wallsGettingNearer[2] = allWalls[4]
		print("Setting third awaiting wall to " + allWalls[4].getDebugId())

func acceptThePosition():
	for i in 3:
		position[i] = futurePosition[i]
