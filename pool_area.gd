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
	var ball1 = ballClass.instantiate()
	ball1.init(Vector3(-6.5, 0., 0.), [wall1, wall2, wall3, wall4, wall5, wall6])
	add_child(ball1)
	balls.append(ball1)
	
	var timer := Timer.new()
	add_child(timer)
	
	timer.wait_time = 3.0
	timer.one_shot = true
	timer.connect("timeout", triggerMovement)
	timer.start()

func triggerMovement():
	print(wall1.normalVector)
	balls[0].setMovement(Vector3(-1., -10., 40.), 
		[wall3, wall1, wall6])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for ball in balls:
		if(ball.isMoving()):
			countNewPositions(ball, delta)
			findCollisions(ball)
			processCollisions(ball)

func countNewPositions(ball, delta):
	ball.countNewPosition(delta)

func findCollisions(ball):
	ball.countWallDistances();

func processCollisions(ball):
	ball.processCollisions()
