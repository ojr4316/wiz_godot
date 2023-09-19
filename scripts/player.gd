extends CharacterBody3D

@export var speed := 10
@export var jumpStrength := 15
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	print("im gonna preeeeeeee");
	


func _input(event):
	if event.is_action_pressed("jump") && is_on_floor():
		print("jump")
		target_velocity.y = jumpStrength;
		
		

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("back"):
		direction.z += 1
	if Input.is_action_pressed("forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$wiz.look_at(position + direction, Vector3.UP)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
