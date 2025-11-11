extends Node;

@onready var user_interface: Control = UserInterface.get_node("user_interface");
@onready var trivia_panel: Panel = user_interface.get_node("trivia_panel");
@onready var trivia_box: VBoxContainer = trivia_panel.get_node("trivia_box");
@onready var title_label: Label = trivia_box.get_node("title");
@onready var trivia_bg: Panel = trivia_box.get_node("trivia_bg");
@onready var trivia_text: Label = trivia_bg.get_node("trivia_text");
@onready var options_box: HBoxContainer = trivia_box.get_node("options");
@onready var next_button: Button = options_box.get_node("next");
@onready var close_button: Button = options_box.get_node("close");

func start_trivia(trivia_array: Array[Array]):
	var currentCamera: Camera2D = PlayerController.currentCamera;
	var currentCharacter: CharacterController = PlayerController.currentCharacter;
	
	var savedZoom: Vector2 = currentCamera.zoom;
	create_tween().tween_property(currentCamera, "zoom", currentCamera.zoom * 2, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	next_button.disabled = false;
	close_button.disabled = true;
	currentCharacter.data.canMove = false;
	trivia_panel.visible = true;
	
	for i in range(trivia_array.size()):
		var trivia_data = trivia_array[i];
		var trivia_title: String = trivia_data[0];
		var trivia: String = trivia_data[1];
		var trivia_time: float = 0;
		if trivia_data.size() > 2:
			next_button.disabled = true;
			trivia_time = trivia_data[2];
		
		title_label.text = trivia_title;
		trivia_text.text = trivia;
		if trivia_time > 0 and i + 1 < trivia_array.size():
			trivia_array.find(trivia_data)
			await get_tree().create_timer(trivia_time).timeout;
			next_button.disabled = false;
			await next_button.pressed;
		else:
			next_button.disabled = false;
	
	next_button.disabled = true;
	close_button.disabled = false;
	await close_button.pressed;
	create_tween().tween_property(currentCamera, "zoom", savedZoom, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);
	currentCharacter.data.canMove = true;
	trivia_panel.visible = false;

func _ready() -> void:
	trivia_panel.visible = false;
