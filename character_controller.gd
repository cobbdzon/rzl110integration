class_name CharacterController extends CharacterBody2D;

@export var data: CharacterData;

@onready var animatedSprite: AnimatedSprite2D = get_node("AnimatedSprite2D");
var chosenAnimDir = "front";
var chosenAnimState = "idle";

func update_camera(delta: float) -> void:
	if data.isPlayer and not data.transitioningScene:
		PlayerController.currentCamera.position = self.position;

func update_anims(delta: float) -> void:
	var currentVelocityLength = velocity.length();
	if currentVelocityLength > 0:
		chosenAnimState = "walk"
		if velocity.y > 0:
			chosenAnimDir = "front";
		elif velocity.y < 0:
			chosenAnimDir = "back";
		
		animatedSprite.flip_h = velocity.x < 0
		if velocity.abs().x > 0:
			chosenAnimDir = "side";
		
		if currentVelocityLength > data.CHAR_SPEED:
			animatedSprite.speed_scale = currentVelocityLength / data.CHAR_SPEED;
		else:
			animatedSprite.speed_scale = 1;
	else:
		chosenAnimState = "idle"

func player_movement() -> void:
	velocity = data.wishDirection.normalized() * (data.CHAR_SPRINT_SPEED if data.wishSprint else data.CHAR_SPEED);
	move_and_slide();

func _physics_process(delta: float) -> void:
	data.wishSprint = Input.is_action_pressed("Sprint");
	data.isPlayer = PlayerController.currentCharacter == self;
	update_camera(delta);
	player_movement();
	update_anims(delta);
	animatedSprite.animation = chosenAnimDir + "_" + chosenAnimState;
