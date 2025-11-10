extends CharacterController;

@onready var detect_area: Area2D = $Area2D;
@onready var ray: RayCast2D = detect_area.get_node("RayCast2D");

var randomMoveTime: float = randi_range(2, 3);
var randomAngle: float = randi_range(0, 360);

func update_anims(delta: float) -> void:
	super.update_anims(delta);
	var currentVelocityLength = velocity.length();
	chosenAnimFlip = false;
	if data.cantMoveTime == 0 and data.canMove and currentVelocityLength > 0:
		if velocity.x > 0:
			chosenAnimDir = "right";
		elif velocity.x < 0:
			chosenAnimDir = "left";

func _on_body_entered(body):
	if body is CharacterController and body.name == "rizal":
		#var rizal: CharacterController = get_tree().current_scene.get_node("rizal");
		print("farted")


func _ready() -> void:
	detect_area.body_entered.connect(_on_body_entered);

func _physics_process(delta: float) -> void:
	ray.target_position = Vector2.from_angle(randomAngle) * 20;
	ray.enabled = true;
	ray.force_raycast_update();
	
	if not ray.is_colliding() and randomMoveTime > 0:
		data.wishDirection = Vector2.from_angle(randomAngle);
		randomMoveTime = clamp(randomMoveTime - delta, 0, INF);
	else:
		print("change direction");
		randomMoveTime = randi_range(3, 6);
		
		if ray.get_collider():
			var angle: float = rad_to_deg(global_position.angle_to(ray.get_collision_point()));
			randomAngle = randf_range(angle - 150, angle + 150);
		else:
			randomAngle = randi_range(0, 360);
	super._physics_process(delta);
