extends Node;

@onready var user_interface: Control = UserInterface.get_node("user_interface");
@onready var quiz_panel: Panel = user_interface.get_node("quiz_panel");
@onready var quiz_box: VBoxContainer = quiz_panel.get_node("quiz_box");
@onready var title_label: Label = quiz_box.get_node("title");
@onready var quiz_bg: Panel = quiz_box.get_node("quiz_bg");
@onready var quiz_question: Label = quiz_bg.get_node("question");
@onready var quiz_answer: Label = quiz_bg.get_node("answer");
@onready var quiz_options_box: GridContainer = quiz_box.get_node("quiz_options");
@onready var options_box: HBoxContainer = quiz_box.get_node("options");
@onready var close_button: Button = options_box.get_node("close");

var quiz_answered: bool = false;

var letters: Array[String] = ["A", "B", "C", "D"];

func check_if_right(quiz_data: QuizData):
	if quiz_answered:
		return
	
	for letter in letters:
		var quiz_button: Button = quiz_options_box.get_node(letter);
		quiz_button.release_focus();
		if letter == quiz_data.correctOption:
			quiz_button.add_theme_color_override("font_color", Color(0.0, 0.392, 0.0, 1.0));
		else:
			quiz_button.add_theme_color_override("font_color", Color(122.958, 0.0, 0.0, 1.0));
	
	quiz_question.visible = false;
	quiz_answer.visible = true;
	
	quiz_answered = true;
	await get_tree().create_timer(1).timeout;
	close_button.disabled = false;

func start_quiz(quiz_data: QuizData):
	var currentCamera: Camera2D = PlayerController.currentCamera;
	var currentCharacter: CharacterController = PlayerController.currentCharacter;
	
	var savedZoom: Vector2 = currentCamera.zoom;
	create_tween().tween_property(currentCamera, "zoom", currentCamera.zoom * 2, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	close_button.disabled = true;
	currentCharacter.data.canMove = false;
	quiz_panel.visible = true;
	
	quiz_question.text = quiz_data.quizQuestion;
	quiz_answer.text = quiz_data.quizAnswer;
	
	quiz_question.visible = true;
	quiz_answer.visible = false;
	
	for letter in letters:
		var quiz_button: Button = quiz_options_box.get_node(letter);
		quiz_button.text = letter + ". " + quiz_data.get("option" + letter);
		quiz_button.pressed.connect(func():
			check_if_right(quiz_data);
		);
	
	while not quiz_answered:
		await get_tree().process_frame;
	
	await close_button.pressed;
	create_tween().tween_property(currentCamera, "zoom", savedZoom, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	currentCharacter.data.canMove = true;
	quiz_panel.visible = false;

func _ready() -> void:
	quiz_panel.visible = false;
