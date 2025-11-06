extends Node2D;

@export var currentScene: Node2D;
@export var HOUSE_EXIT: Area2D;

func enter_transition_point(body: Node2D):
	if body == PlayerController.currentCharacter:
		PlayerController.nextScene = "outside"
		PlayerController.wishTransitionScene = true;

func _ready() -> void:
	currentScene = get_tree().current_scene;
	HOUSE_EXIT = currentScene.get_node("%HouseExit");
	HOUSE_EXIT.connect("body_entered", enter_transition_point);
