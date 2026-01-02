extends CharacterBody3D


@export var ACCELERATION := 30.0
@export var TILT_ANGLE := 4

@export var LATERAL_FRICTION = 0.85
@export var FORWARD_FRICTION = 0.98


func _physics_process(delta: float) -> void:
	
	var forward_dir := transform.basis.z.normalized()
	var right_dir := transform.basis.x.normalized()
	
	# Decomposed velocity into forward velocity & side (lateral) velocity
	var forward_velocity = forward_dir * velocity.dot(forward_dir)
	var lateral_velocity = right_dir * velocity.dot(right_dir)
	
	lateral_velocity *= LATERAL_FRICTION
	
	velocity = forward_velocity + lateral_velocity
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	var throttle := Input.get_axis("backward", "forward")
	if direction:
		rotation.y += TILT_ANGLE * direction * (sqrt(velocity.length()) / 10) * delta
	
	if throttle:
		velocity += forward_dir * throttle * ACCELERATION * delta
	else:
		velocity *= FORWARD_FRICTION


	move_and_slide()
