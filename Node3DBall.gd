class_name Ball extends Node3D

var speed
var futurePosition
var inMovement := false

var allWalls
var wallsGettingNearer := []
var distancesFromWalls := [-1., -1., -1.]

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = Vector3(0., 0., 0.)

func init(positioning, walls):
	position = positioning
	allWalls = walls

func setMovement(newSpeed, walls):
	speed = newSpeed
	wallsGettingNearer = walls
	inMovement = true

func countNewPosition(delta):
	var position_delta := Vector3(delta * speed[0], delta * speed[1], delta * speed[2])
	futurePosition = position + position_delta

func countWallDistances():
	for i in 3:	
		distancesFromWalls[i] = countFutureDistanceToWall(wallsGettingNearer[i])

func countFutureDistanceToWall(wall):
	return wall.normalVector.dot(futurePosition - wall.nominalPoint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var position_delta := Vector3(delta * speed[0], delta * speed[1], delta * speed[2])
	var new_position := position + position_delta
	var Wall := $"../Room/Wall3"
	var distance :float = Wall.normalVector.dot(new_position - Wall.nominalPoint)
	print(distance)
	if(distance >= 0):
		translate(position_delta)
	else:
		speed = speed * -1 * abs(Wall.normalVector)

func isMoving():
	return inMovement

func processCollisions():
	for i in 3:
		if(distancesFromWalls[i] < 0):
			switchWallOnCollision(i)
		else:
			position[i] = futurePosition[i]

func switchWallOnCollision(i):
	speed[i] = -speed[i]
	
	var switchWallPlus
	var switchWallMinus
	if(i == 0):
		switchWallPlus = allWalls[2]
		switchWallMinus = allWalls[3]
	elif(i == 1):
		switchWallPlus = allWalls[1]
		switchWallMinus = allWalls[0]
	else:
		switchWallPlus = allWalls[5]
		switchWallMinus = allWalls[4]
	
	if(speed[i] < 0):
		wallsGettingNearer[i] = switchWallMinus
	else:
		wallsGettingNearer[i] = switchWallPlus
