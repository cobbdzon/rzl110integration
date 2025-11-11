extends Control

const SCENE_DELAY: float = 1;
const STARTING_SCENE: String = "rizal_bedroom";

@onready var user_interface = UserInterface.get_node("user_interface");
@onready var transition_panel: Panel = user_interface.get_node("transition_fade");

@onready var currentScene: Control = get_tree().current_scene;
@onready var startButton: Button = currentScene.get_node("%start");
@onready var creditsButton: Button = currentScene.get_node("%credits");
@onready var creditsPanel: Panel = currentScene.get_node("%credits_panel");
@onready var creditsBack: Button = creditsPanel.get_node("credits_back");

func _on_start_pressed():
	create_tween().tween_property(transition_panel, "modulate:a", 1, SCENE_DELAY);
	await get_tree().create_timer(SCENE_DELAY).timeout;
	get_tree().change_scene_to_file("res://scenes/" + STARTING_SCENE + ".tscn");

func _on_credits_pressed():
	creditsPanel.visible = true;

func _on_credits_back_pressed():
	creditsPanel.visible = false;

func _ready() -> void:
	creditsPanel.visible = false;
