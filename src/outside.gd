extends Node2D;

@export var HOUSE_ENTRANCE: Area2D;
@export var can_enter: bool = false;

func enter_transition_point(body: Node2D):
	if can_enter and body == PlayerController.currentCharacter and PlayerController.currentCharacter.name == "rizal":
		PlayerController.nextScene = "rizal_bedroom"
		PlayerController.wishTransitionScene = true;

func spawn_if_not_exist(charName: String, pos: Vector2):
	if not has_node(charName):
		PlayerController.spawn_character(charName, pos);

func _scene_ready():
	spawn_if_not_exist("usman", Vector2(152, 350));
	get_tree().create_timer(1).timeout.connect(func():
		HintsController.make_hint("Hint: Point using mouse and press T to throw stick", 6, true);
	);

func _ready() -> void:
	HOUSE_ENTRANCE = get_node("%HouseEntrance");
	HOUSE_ENTRANCE.connect("body_entered", enter_transition_point);

	if PlayerController.currentCharacter.data.lastScene == "rizal_bedroom":
		PlayerController.currentCharacter.global_position = HOUSE_ENTRANCE.global_position + Vector2(0, 20);
