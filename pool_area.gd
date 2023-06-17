extends Node3D

var ball := load("res://node3dBall.tscn") as PackedScene;

# Called when the node enters the scene tree for the first time.
func _ready():
	var ball1 = ball.instantiate()
	ball1.position = Vector3(-6.5, 0., 0.)
	add_child(ball1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
