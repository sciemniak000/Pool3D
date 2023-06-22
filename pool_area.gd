extends Node3D

var ballClass := load("res://node3dBall.tscn") as PackedScene;

var balls := []
@onready var wall1 := $Room/Wall1
@onready var wall2 := $Room/Wall2
@onready var wall3 := $Room/Wall3
@onready var wall4 := $Room/Wall4
@onready var wall5 := $Room/Wall5
@onready var wall6 := $Room/Wall6

var ballsCollidingLeft := []
var ballsCollidingRight := []

# Called when the node enters the scene tree for the first time.
func _ready():
	createBall(Vector3(-48.63, -40., 0.49))
	createBall(Vector3(-49., 40., 0.))
	
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
	balls[0].setMovement(Vector3(0., 40., 0.))
	balls[1].setMovement(Vector3(0., -40., 0.))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	
	for i in range(balls.size()):
		for j in range(i + 1, balls.size()):
			var distance = sqrt(pow(balls[i].futurePosition[0] - balls[j].futurePosition[0], 2) 
			+ pow(balls[i].futurePosition[1] - balls[j].futurePosition[1], 2)
			+ pow(balls[i].futurePosition[2] - balls[j].futurePosition[2], 2))
			if distance <= balls[i].radius + balls[j].radius:
				ballsCollidingLeft.append(balls[i])
				ballsCollidingRight.append(balls[j])

func processCollisions(delta):
	for ball in balls:
		if ball.isMoving():
			ball.processCollisions()
	
	for i in range(min(ballsCollidingLeft.size(), ballsCollidingRight.size())):
		var ball1 = ballsCollidingLeft[i]
		var ball2 = ballsCollidingRight[i]
		var normalVector = getNormalVector(ball1, ball2)
		#var normalVector = Vector3(0., 0.7071, -0.7071)
		print("normal vector calculated to: " + str(normalVector))
		var collisionSpeed1 = countCollisionSpeed(normalVector, ball1)
		var collisionSpeed2 = countCollisionSpeed(normalVector, ball2)
		print("collision vectors calculated 1 to: " + str(collisionSpeed1) + "; and 2 to: " + str(collisionSpeed2))
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
	print("Pos1: " + str(pos1))
	#var pos1 = Vector3(-49., -0.353553, 0.353553)
	var pos2 = ball2.position + (ball2.futurePosition - ball2.position) * proportion
	print("Pos2: " + str(pos2))
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
	for ball in balls:
		if ball.isMoving():
			ball.acceptThePosition()
