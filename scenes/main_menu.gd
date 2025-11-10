extends Control

const STARTING_SCENE: String = "rizal_bedroom";

@onready var currentScene: Control = get_tree().current_scene;
@onready var startButton: Button = currentScene.get_node("%start");
@onready var creditsButton: Button = currentScene.get_node("%credits");
@onready var creditsPanel: Panel = currentScene.get_node("%credits_panel");
@onready var creditsBack: Button = creditsPanel.get_node("credits_back");

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/" + STARTING_SCENE + ".tscn");

func _on_credits_pressed():
	creditsPanel.visible = true;

func _on_credits_back_pressed():
	creditsPanel.visible = false;

func _ready() -> void:
	creditsPanel.visible = false;
