extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export var ACCELERATION := 300.0
@export var TILT_ANGLE := 1.7

@export var LATERAL_FRICTION := 0.85
@export var FORWARD_FRICTION := 0.98


func _physics_process(delta: float) -> void:
	
	var forward_dir := (transform.x - transform.y).normalized()
	var right_dir := (transform.x + transform.y) / 2
	
	# Decomposed velocity into forward velocity & side (lateral) velocity
	var forward_velocity := forward_dir * velocity.dot(forward_dir)
	var lateral_velocity := right_dir * velocity.dot(right_dir)

	if rotation_degrees >= -45 and rotation_degrees < 135:
		sprite.flip_h = false
		sprite.rotation_degrees = 0
	else:
		sprite.flip_h = true
		sprite.rotation_degrees = 90
	
	lateral_velocity *= LATERAL_FRICTION
	
	velocity = forward_velocity + lateral_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	var throttle := Input.get_axis("backward", "forward")
	if direction:
		rotation += TILT_ANGLE * direction * (sqrt(velocity.length()) / 10) * delta
	
	if throttle:
		velocity += forward_dir * throttle * ACCELERATION * delta
	else:
		velocity *= FORWARD_FRICTION


	move_and_slide()
