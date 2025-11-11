extends CharacterController;

@onready var detect_area: Area2D = $Area2D;
@onready var ray: RayCast2D = detect_area.get_node("RayCast2D");

var randomMoveTime: float = randi_range(2, 3);
var randomAngle: float = randi_range(0, 360);

var canBeInteracted: bool = false;
var hasHinted: bool = false;
var isTalking: bool = false;

func update_anims(delta: float) -> void:
	super.update_anims(delta);
	var currentVelocityLength = velocity.length();
	chosenAnimFlip = false;
	if data.cantMoveTime == 0 and data.canMove and currentVelocityLength > 0:
		if velocity.x > 0:
			chosenAnimDir = "right";
		elif velocity.x < 0:
			chosenAnimDir = "left";

func _quest_update(rizal: CharacterController):
	if isTalking:
		return
	isTalking = true;
	data.canMove = false;
	if rizal.data.questState == 0:
		var dialog_array: Array[Array] = [
			[data.displayName, "Pepe, you’ve been reading all morning.", 1],
			[rizal.data.displayName, "I just want to learn more, Mother.", 1],
			[data.displayName, "Learning is good, but you also need rest.", 1],
			[data.displayName, "Go outside and play with Usman.", 1],
			[data.displayName, "Fresh air will help your mind.", 1],
		]
		await DialogController.start_dialog(dialog_array);
		rizal.data.questState = 1;
		rizal.data.cantMoveTime += 3;
		data.canMove = true;
		HintsController.make_hint("New Quest: Play with Usman in the backyard!", 3, true);
		HintsController.make_hint("Hint: Go outside through the door", 3, false);
		await HintsController.hint_completed;
		PlayerController.currentScene.can_exit = true;
	elif rizal.data.questState == 1:
		var dialog_array: Array[Array] = [
			[data.displayName, "Pepe, I told you to play with Usman!", 1],
		]
		await DialogController.start_dialog(dialog_array);
		data.canMove = true;
		HintsController.make_hint("Hint: Go outside through the door", 3, false);
	elif rizal.data.questState == 2:
		PlayerController.currentScene.can_exit = false;
		var dialog_array: Array[Array] = [
			[data.displayName, "Nice work, Pepe. Usman enjoyed that.", 1],
			[rizal.data.displayName, "He really likes running after the stick, Mother.", 1],
			[data.displayName, "He does. He’s patient and doesn’t give up easily.", 1],
			[data.displayName, "Try to be like that too — steady and determined.", 1],
			[rizal.data.displayName, "I understand, Mother.", 1],
		]
		await DialogController.start_dialog(dialog_array);
		rizal.data.questState = 3;
		data.canMove = true;
		HintsController.make_hint("Quest Completed: A Mother’s Lesson", 3, true);
		await HintsController.hint_completed;
		
		canBeInteracted = false;
		
		var trivia_title: String = "Did You Know?";
		var trivia_array: Array[Array] = [
			[trivia_title, "Teodora Alonso was Jose Rizal’s first teacher.", 0.2],
			[trivia_title, "She taught him reading, writing, and good manners.", 0.2],
			[trivia_title, "She also taught him to stay kind and disciplined, even during playtime!", 0.2],
		]
		await TriviaController.start_trivia(trivia_array);
		
		await get_tree().create_timer(1).timeout;
		
		var quiz_data: QuizData = load("res://quizzes/level1.tres");
		await QuizController.start_quiz(quiz_data);
		
		PlayerController.currentScene.can_exit = true;
		
	isTalking = false;

#func _on_body_entered(body):
	#if body is CharacterController and body.name == "rizal":
		#_quest_update(body);
#
func _ready() -> void:
	while not canBeInteracted:
		canBeInteracted = PlayerController.currentCharacter.data.doneBasicTutorial;
		await get_tree().process_frame;

func _physics_process(delta: float) -> void:
	ray.target_position = Vector2.from_angle(randomAngle) * 20;
	ray.enabled = true;
	ray.force_raycast_update();
	
	$interactable.visible = canBeInteracted;
	if canBeInteracted and detect_area.get_overlapping_bodies().find(PlayerController.currentCharacter) > 0:
		$interactable.add_theme_color_override("font_color", Color(255, 255, 0));
		if not hasHinted:
			hasHinted = true;
			HintsController.make_hint("Hint: Press E to interact", 4, true);
		if Input.is_action_just_pressed("Interact"):
			_quest_update(PlayerController.currentCharacter);
	else:
		$interactable.add_theme_color_override("font_color", Color(255, 0, 0));
	
	if not ray.is_colliding() and randomMoveTime > 0:
		data.wishDirection = Vector2.from_angle(randomAngle);
		randomMoveTime = clamp(randomMoveTime - delta, 0, INF);
	else:
		randomMoveTime = randi_range(3, 6);
		
		if ray.get_collider():
			var angle: float = rad_to_deg(global_position.angle_to(ray.get_collision_point()));
			randomAngle = randf_range(angle - 150, angle + 150);
		else:
			randomAngle = randi_range(0, 360);
	super._physics_process(delta);
