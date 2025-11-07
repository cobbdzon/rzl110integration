class_name CharacterController extends CharacterBody2D;

@export var data: CharacterData;

@onready var animatedSprite: AnimatedSprite2D = get_node("AnimatedSprite2D");
var chosenAnimDir = "front";
var chosenAnimState = "idle";

func load_data():
	global_position = data.scenePosition;
	chosenAnimDir = data.lastAnimDir;

func update_camera(delta: float) -> void:
	if data.isPlayer and not PlayerController.wishTransitionScene:
		PlayerController.currentCamera.position = self.position;

func update_anims(delta: float) -> void:
	var currentVelocityLength = velocity.length();
	if data.cantMoveTime == 0 and data.canMove and currentVelocityLength > 0:
		animatedSprite.speed_scale = currentVelocityLength / data.CHAR_SPEED;
		
		chosenAnimState = "walk"
		if velocity.y > 0:
			chosenAnimDir = "front";
		elif velocity.y < 0:
			chosenAnimDir = "back";
		
		animatedSprite.flip_h = velocity.x < 0
		if velocity.abs().x > 0:
			chosenAnimDir = "side";
	else:
		animatedSprite.speed_scale = 1;
		chosenAnimState = "idle"
	
	data.lastAnimDir = chosenAnimDir;

func player_movement(delta: float) -> void:
	if data.cantMoveTime == 0 and data.canMove:
		var speed = data.CHAR_SPRINT_SPEED if data.wishSprint else data.CHAR_SPEED;
		var wishVelocity = velocity.move_toward(data.wishDirection.normalized() * speed, data.CHAR_ACCEL * delta);
		velocity = wishVelocity;
		move_and_slide();
	else:
		data.cantMoveTime = clamp(data.cantMoveTime - delta, 0, INF);

func _physics_process(delta: float) -> void:
	data.wishSprint = Input.is_action_pressed("Sprint");
	data.isPlayer = PlayerController.currentCharacter == self;
	update_camera(delta);
	player_movement(delta);
	update_anims(delta);
	animatedSprite.animation = chosenAnimDir + "_" + chosenAnimState;
