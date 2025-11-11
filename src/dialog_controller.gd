extends Node;

@onready var user_interface: Control = UserInterface.get_node("user_interface");
@onready var dialog_panel: Panel = user_interface.get_node("dialog_panel");
@onready var dialog_box: VBoxContainer = dialog_panel.get_node("dialog_box");
@onready var speaker_label: Label = dialog_box.get_node("speaker");
@onready var dialog_bg: Panel = dialog_box.get_node("dialog_bg");
@onready var dialog_text: Label = dialog_bg.get_node("dialog_text");
@onready var options_box: HBoxContainer = dialog_box.get_node("options");
@onready var next_button: Button = options_box.get_node("next");
@onready var close_button: Button = options_box.get_node("close");

func start_dialog(dialog_array: Array[Array]):
	var currentCamera: Camera2D = PlayerController.currentCamera;
	var currentCharacter: CharacterController = PlayerController.currentCharacter;
	
	var savedZoom: Vector2 = currentCamera.zoom;
	currentCamera.zoom = currentCamera.zoom * 2;
	next_button.disabled = false;
	close_button.disabled = true;
	currentCharacter.data.canMove = false;
	dialog_panel.visible = true;
	
	for i in range(dialog_array.size()):
		var dialog_data = dialog_array[i];
		var speaker: String = dialog_data[0];
		var dialog: String = dialog_data[1];
		var dialog_time: float = 0;
		if dialog_data.size() > 2:
			next_button.disabled = true;
			dialog_time = dialog_data[2];
		
		speaker_label.text = speaker;
		dialog_text.text = dialog;
		if dialog_time > 0 and i + 1 < dialog_array.size():
			dialog_array.find(dialog_data)
			await get_tree().create_timer(dialog_time).timeout;
			next_button.disabled = false;
			await next_button.pressed;
		else:
			next_button.disabled = false;
	
	next_button.disabled = true;
	close_button.disabled = false;
	await close_button.pressed;
	currentCamera.zoom = savedZoom;
	currentCharacter.data.canMove = true;
	dialog_panel.visible = false;

func _ready() -> void:
	dialog_panel.visible = false;
