extends Node3D

var ballClass := load("res://node3dBall.tscn") as PackedScene;

var balls := []
@onready var wall1 := $Room/Wall1
@onready var wall2 := $Room/Wall2
@onready var wall3 := $Room/Wall3
@onready var wall4 := $Room/Wall4
@onready var wall5 := $Room/Wall5
@onready var wall6 := $Room/Wall6

# Called when the node enters the scene tree for the first time.
func _ready():
	createBall(Vector3(-49., 0., 0.))
	
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
	balls[0].setMovement(Vector3(-40., 20., 10.))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for ball in balls:
		if(ball.isMoving()):
			countFuturePositions(ball, delta)
			findCollisions(ball)
			processCollisions(ball)
	
	for ball in balls:
		if(ball.isMoving()):
			ball.acceptThePosition()

func countFuturePositions(ball, delta):
	ball.countNewPosition(delta)

func findCollisions(ball):
	ball.countWallDistances();

func processCollisions(ball):
	ball.processCollisions()
