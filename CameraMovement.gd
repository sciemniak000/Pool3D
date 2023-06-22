extends Camera3D

var isMoving := false
var lastMousePosition
var newMousePosition
var controlXRotation

# Called when the node enters the scene tree for the first time.
func _ready():
	controlXRotation = rotation[2]

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				lastMousePosition = event.position
				isMoving = true
			else:
				isMoving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isMoving:
		newMousePosition = get_viewport().get_mouse_position()
		rotate_y((newMousePosition.x - lastMousePosition.x) * 0.2 * delta)
		rotate_z((newMousePosition.y - lastMousePosition.y) * 0.2 * delta)
		rotation[2] = controlXRotation
		#rotate_z((newMousePosition.z - lastMousePosition.z) * 100.1 * delta)
		lastMousePosition = newMousePosition
