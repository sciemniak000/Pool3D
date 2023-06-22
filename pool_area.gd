extends Node3D

var ballClass := load("res://node3dBall.tscn") as PackedScene;

var balls := []
@onready var wall1 := $Room/Wall1
@onready var wall2 := $Room/Wall2
@onready var wall3 := $Room/Wall3
@onready var wall4 := $Room/Wall4
@onready var wall5 := $Room/Wall5
@onready var wall6 := $Room/Wall6

var ballsClusters = []
var ballsCollidingLeft := []
var ballsCollidingRight := []
var rng = RandomNumberGenerator.new()
var amountOfBalls = 1000
var maxSpeed = 30.0

var debugCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 10:
		ballsClusters.append([])
		for j in 10:
			ballsClusters[i].append([])
			for k in 10:
				ballsClusters[i][j].append([])
	for i in amountOfBalls:
		createBall(Vector3(rng.randf_range(-1., -97.), rng.randf_range(-48., 48.), rng.randf_range(-48., 48.)))
	
	var timer := Timer.new()
	add_child(timer)
	
	timer.wait_time = 1.5
	timer.one_shot = true
	timer.connect("timeout", triggerMovement)
	timer.start()
	

func createBall(positioning):
	var ball = ballClass.instantiate()
	ball.init(positioning, [wall1, wall2, wall3, wall4, wall5, wall6])
	add_child(ball)
	balls.append(ball)

func triggerMovement():
	for i in amountOfBalls:
		balls[i].setMovement(Vector3(rng.randf_range(-maxSpeed, maxSpeed), rng.randf_range(-maxSpeed, maxSpeed)
				, rng.randf_range(-maxSpeed, maxSpeed)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	countFuturePositions(delta)
	findCollisions()
	processCollisions(delta)
	proceedToPosition()

func countFuturePositions(delta):
	for ball in balls:
		if ball.isMoving():
			ball.countNewPosition(delta)

func findCollisions():
	for ball in balls:
		if ball.isMoving():
			ball.countWallDistances();
	
	for i in ballsClusters.size():
		for j in ballsClusters[i].size():
			for k in ballsClusters[i][j].size():
				for x in range(ballsClusters[i][j][k].size()):
					for y in range(x + 1, ballsClusters[i][j][k].size()):
						var distance = sqrt(pow(ballsClusters[i][j][k][x].futurePosition[0] - ballsClusters[i][j][k][y].futurePosition[0], 2) 
						+ pow(ballsClusters[i][j][k][x].futurePosition[1] - ballsClusters[i][j][k][y].futurePosition[1], 2)
						+ pow(ballsClusters[i][j][k][x].futurePosition[2] - ballsClusters[i][j][k][y].futurePosition[2], 2))
						if distance <= ballsClusters[i][j][k][x].radius + ballsClusters[i][j][k][y].radius:
							ballsCollidingLeft.append(ballsClusters[i][j][k][x])
							ballsCollidingRight.append(ballsClusters[i][j][k][y])

func processCollisions(delta):
	for ball in balls:
		if ball.isMoving():
			ball.processCollisions()
	
	for i in range(min(ballsCollidingLeft.size(), ballsCollidingRight.size())):
		var ball1 = ballsCollidingLeft[i]
		var ball2 = ballsCollidingRight[i]
		var normalVector = getNormalVector(ball1, ball2)
		#var normalVector = Vector3(0., 0.7071, -0.7071)
		var collisionSpeed1 = countCollisionSpeed(normalVector, ball1)
		var collisionSpeed2 = countCollisionSpeed(normalVector, ball2)
		processBallsCollision(delta, ball1, ball2, collisionSpeed1, collisionSpeed2)
	
	ballsCollidingLeft.clear()
	ballsCollidingRight.clear()

func getNormalVector(ball1, ball2):
	var collisionDistance = ball1.radius + ball2.radius
	var positionDistance = sqrt(pow(ball1.position[0] - ball2.position[0], 2) 
			+ pow(ball1.position[1] - ball2.position[1], 2)
			+ pow(ball1.position[2] - ball2.position[2], 2))
	var futureDistance = sqrt(pow(ball1.futurePosition[0] - ball2.futurePosition[0], 2) 
			+ pow(ball1.futurePosition[1] - ball2.futurePosition[1], 2)
			+ pow(ball1.futurePosition[2] - ball2.futurePosition[2], 2))
	var proportion = (positionDistance - collisionDistance)/(positionDistance - futureDistance)
	
	var pos1 = ball1.position + (ball1.futurePosition - ball1.position) * proportion
	#var pos1 = Vector3(-49., -0.353553, 0.353553)
	var pos2 = ball2.position + (ball2.futurePosition - ball2.position) * proportion
	#var pos2 = Vector3(-49., 0.353553, -0.353553)
	var dif = pos2 - pos1
	return dif/sqrt(pow(dif[0], 2) + pow(dif[1], 2) + pow(dif[2], 2))

func countCollisionSpeed(normalVector, ball):
	return normalVector.dot(ball.speed)*normalVector

func processBallsCollision(delta, ball1, ball2, collisionSpeed1, collisionSpeed2):
	var unimpactedSpeed1 = ball1.speed - collisionSpeed1
	var unimpactedSpeed2 = ball2.speed - collisionSpeed2
	
	ball1.countNewPositionWithPartialSpeed(delta, unimpactedSpeed1)
	ball2.countNewPositionWithPartialSpeed(delta, unimpactedSpeed2)
	
	ball1.setMovement(unimpactedSpeed1 + collisionSpeed2)
	ball2.setMovement(unimpactedSpeed2 + collisionSpeed1)

func proceedToPosition():
	for i in 10:
		for j in 10:
			for k in 10:
				ballsClusters[i][j][k].clear()
	
	for ball in balls:
		if ball.isMoving():
			ball.acceptThePosition()
			ball.assignTheSpaceIndices()
			assignTheSpaceIndicesToCluster(ball)
			

func assignTheSpaceIndicesToCluster(ball):
	var spaceIndices = ball.doubleIndexRegister
	for i in spaceIndices[0].size():
		for j in spaceIndices[1].size():
			for k in spaceIndices[2].size():
				ballsClusters[spaceIndices[0][i]][spaceIndices[1][j]][spaceIndices[2][k]].append(ball)
	spaceIndices[0].clear()
	spaceIndices[1].clear()
	spaceIndices[2].clear()
