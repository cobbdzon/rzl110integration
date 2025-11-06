extends Node2D;

@export var currentScene: Node2D;
@export var HOUSE_ENTRANCE: Area2D;

func enter_transition_point(body: Node2D):
	if body == PlayerController.currentCharacter:
		PlayerController.nextScene = "rizal_bedroom"
		PlayerController.wishTransitionScene = true;

func _ready() -> void:
	print("ready outside")
	currentScene = get_tree().current_scene;
	HOUSE_ENTRANCE = currentScene.get_node("%HouseEntrance");
	HOUSE_ENTRANCE.connect("body_entered", enter_transition_point);
	
	if PlayerController.currentCharacter.data.lastScene == "rizal_bedroom":
		print(PlayerController.currentCharacter.data.scenePosition, "fart");
		PlayerController.currentCharacter.global_position = Vector2(264.0, 309);
	
