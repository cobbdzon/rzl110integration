class_name Stick extends RigidBody2D;

@export var throw_force: float = 200;
@export var friction: float = 2;
@export var stop_threshold: float = 20.0;

var thrown: bool = false;

func _ready():
	gravity_scale = 0;

func throw_stick(direction: Vector2):
	thrown = true;
	sleeping = false;  # make sure physics wakes up
	linear_velocity = direction.normalized() * throw_force;

func _integrate_forces(state):
	if thrown:
		# Apply simple friction (in physics-safe way)
		var new_vel = state.linear_velocity.move_toward(Vector2.ZERO, friction);
		state.linear_velocity = new_vel;

		# Stop completely when nearly stationary
		if new_vel.length() < stop_threshold:
			state.linear_velocity = Vector2.ZERO;
			thrown = false;
			sleeping = true;
