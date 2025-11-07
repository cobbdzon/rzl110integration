extends Node2D;

@export var HOUSE_ENTRANCE: Area2D;

func enter_transition_point(body: Node2D):
	if body == PlayerController.currentCharacter and PlayerController.currentCharacter.name == "rizal":
		PlayerController.nextScene = "rizal_bedroom"
		PlayerController.wishTransitionScene = true;

func spawn_if_not_exist(charName: String, pos: Vector2):
	if not has_node(charName):
		PlayerController.spawn_character(charName, pos);

func _scene_ready():
	spawn_if_not_exist("usman", Vector2(152, 350));

func _ready() -> void:
	HOUSE_ENTRANCE = get_node("%HouseEntrance");
	HOUSE_ENTRANCE.connect("body_entered", enter_transition_point);

	if PlayerController.currentCharacter.data.lastScene == "rizal_bedroom":
		PlayerController.currentCharacter.global_position = HOUSE_ENTRANCE.global_position + Vector2(0, 20);
