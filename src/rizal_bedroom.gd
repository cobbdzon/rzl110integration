extends Node2D;

@export var HOUSE_EXIT: Area2D;

func enter_transition_point(body: Node2D):
	if body == PlayerController.currentCharacter and PlayerController.currentCharacter.name == "rizal":
		PlayerController.nextScene = "outside"
		PlayerController.wishTransitionScene = true;

func spawn_if_not_exist(charName: String, pos: Vector2):
	
	if not has_node(charName):
		PlayerController.spawn_character(charName, pos);

func _scene_ready():
	spawn_if_not_exist("mother", Vector2(40, 67));

func _ready() -> void:
	PlayerController._start_game();
	
	HOUSE_EXIT = get_node("%HouseExit");
	HOUSE_EXIT.connect("body_entered", enter_transition_point);
	
	if PlayerController.currentCharacter.data.lastScene == "outside":
		PlayerController.currentCharacter.global_position = HOUSE_EXIT.global_position + Vector2(0, 20);
