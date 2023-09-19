extends CharacterBody3D

@export var speed := 8
@export var jumpStrength := 12
@export var fall_acceleration = 50

var target_velocity = Vector3.ZERO
var ball: PackedScene

signal swipe
var swipe_start: Vector2
var min_drag := 100


# Called when the node enters the scene tree for the first time.
func _ready():
	print("im gonna preeeeeeee")
	ball = load("res://scenes/ball.tscn")
	print(ball)
	
	swipe.connect(trySwipe)
	
func trySwipe(e):
	print(e)
	var b = ball.instantiate()
	get_parent().add_child(b)
	b.global_position = Vector3(position.x, position.y, position.z-1)
	match e:
		"left":
			(b as RigidBody3D).apply_impulse(Vector3(-5, 1, 0))
		"right":
			(b as RigidBody3D).apply_impulse(Vector3(5, 1, 0))

var drag: bool = false

func calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var s = swipe_end - swipe_start
	print(s)
	if abs(s.x) > min_drag:
		if s.x > 0:
			swipe.emit("right")
			#emit_signal("swipe", "right")
		else:
			swipe.emit("left")
			
func _input(event):
	if event.is_action_pressed("interact"):
		swipe_start = event.position
	if event.is_action_released("interact"):
		calculate_swipe(event.position)
			
	if event.is_action_pressed("jump") && is_on_floor():
		target_velocity.y = jumpStrength

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
func _process(_delta):
	pass
