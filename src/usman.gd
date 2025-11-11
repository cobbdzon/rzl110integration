extends CharacterController;

@onready var detect_area = $Area2D

var returnStickCount: int = 0;

func update_anims(delta: float) -> void:
	super.update_anims(delta);
	if velocity.length() > 60 and chosenAnimDir == "side":
		chosenAnimState = "run";

func _on_body_entered(body: Node):
	if body.name == "stick" and body.sleeping:
		data.hasStick = true;
		body.queue_free()
		if returnStickCount == 0:
			HintsController.make_hint("Return the stick to Rizal", 2, true)
	elif body.name == "rizal":
		if data.hasStick:
			var rizal: CharacterController = get_tree().current_scene.get_node("rizal");
			PlayerController.change_character(rizal);
			rizal.data.canMove = false;
			returnStickCount += 1;
			if returnStickCount <= 5 and rizal.data.questState == 1:
				HintsController.make_hint("Played fetch for " + str(returnStickCount) + "/5 times", 3, true);
			get_tree().create_timer(0.5).timeout.connect(func():
				rizal.data.canMove = true;
				data.hasStick = false;
				rizal.data.hasStick = true;
				if returnStickCount == 5 and rizal.data.questState == 1:
					rizal.data.questState = 2;
					HintsController.make_hint("Quest Completed: Play with Usman", 3, true);
					HintsController.make_hint("Go back inside to continue", 3, false);
					await HintsController.hint_completed;
					PlayerController.currentScene.can_enter = true;
			)

func _ready() -> void:
	diagonalConstant = 1;
	detect_area.body_entered.connect(_on_body_entered);

func _physics_process(delta: float) -> void:
	if data.isPlayer:
		data.wishDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	else:
		data.wishDirection = Vector2.ZERO;
	super._physics_process(delta);
