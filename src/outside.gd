extends Node2D;

@export var currentScene: Node2D;
@export var HOUSE_ENTRANCE: Area2D;

func enter_transition_point(body: Node2D):
	if body == PlayerController.currentCharacter:
		PlayerController.nextScene = "rizal_bedroom"
		PlayerController.wishTransitionScene = true;

func _ready() -> void:
	currentScene = get_tree().current_scene;
	HOUSE_ENTRANCE = currentScene.get_node("%HouseEntrance");
	HOUSE_ENTRANCE.connect("body_entered", enter_transition_point);

	if PlayerController.currentCharacter.data.lastScene == "rizal_bedroom":
		PlayerController.currentCharacter.global_position = HOUSE_ENTRANCE.global_position + Vector2(0, 20);
