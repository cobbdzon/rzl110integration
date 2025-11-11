extends Node;

const SCENE_CANMOVE_DELAY: float = 1;
const STARTING_SCENE: String = "rizal_bedroom";

signal scene_changed(new_scene: Node2D);

@export var starter_character_name: String = "rizal";

@onready var user_interface = UserInterface.get_node("user_interface");
@onready var transition_panel: Panel = user_interface.get_node("transition_fade");

var gameStarted: bool = false;

var currentScene: Node2D;
var currentCharacter: CharacterController;
var currentCamera: Camera2D;

var transitioning: bool = false;

# scene management
var nextScene: String = "outside";
var wishTransitionScene: bool = false;

var characterSnapshots: Dictionary[String, CharacterData];

func change_scene_to(scene: String):
	currentCharacter.data.transitioningScene = true;
	transitioning = false;
	currentCharacter.data.canMove = false;
	
	create_tween().tween_property(transition_panel, "modulate:a", 1, SCENE_CANMOVE_DELAY / 2);
	
	await get_tree().create_timer(SCENE_CANMOVE_DELAY / 2).timeout
	
	# save positions of non-characters
	for character in get_scene_characters():
		character.data.scenePosition = character.global_position;
		character.data.lastScene = currentScene.name;
		characterSnapshots[character.name] = character.data;
	
	if currentCharacter:
		currentCharacter.data.lastScene = currentScene.name;
		currentCharacter.get_parent().remove_child(currentCharacter);
	
	# Change scene
	get_tree().change_scene_to_file("res://scenes/" + scene + ".tscn");
	
	while get_tree().current_scene == null:
		await get_tree().process_frame;
	
	currentScene = get_tree().current_scene;
	currentCamera = currentScene.get_node("%Camera")
	
	#load non-characters
	for charName in characterSnapshots.keys():
		var data: CharacterData = characterSnapshots[charName];
		if data.lastScene == scene and not data.isPlayer:
			var character_scene = load("res://characters/" + charName + ".tscn");
			if character_scene:
				var character: CharacterController = character_scene.instantiate();
				character.data = data;
				character.load_data();
				currentScene.add_child(character);
	
	if currentCharacter:
		currentScene.add_child(currentCharacter);
		#currentCharacter.global_position = characterSnapshots[currentCharacter.name].scenePosition;
		get_tree().create_timer(SCENE_CANMOVE_DELAY).timeout.connect(func ():
			currentCharacter.data.transitioningScene = false;
			transitioning = false;
			currentCharacter.data.canMove = true;
			create_tween().tween_property(transition_panel, "modulate:a", 0, SCENE_CANMOVE_DELAY / 2);
		)
	
	emit_signal("scene_changed", currentScene);
	if currentScene.has_method("_scene_ready"):
		currentScene._scene_ready();

func spawn_character(char_name: String, spawn_position: Vector2) -> CharacterController:
	var character_scene: PackedScene = load("res://characters/" + char_name + ".tscn");
	var instance: CharacterController = character_scene.instantiate() as CharacterController;
	currentScene.add_child(instance);
	instance.global_position = spawn_position;
	return instance;

func spawn_starter_character() -> void:
	if starter_character_name == null:
		push_error("Starter character scene not set!")
		return

	currentCharacter = spawn_character(starter_character_name, Vector2(-15, 6));
	currentCharacter.data.isPlayer = true
	
	HintsController.make_hint("Hint: Use ARROW KEYS to move", 6, true);
	var hasUsedArrowKeys = false;
	while not hasUsedArrowKeys:
		await get_tree().process_frame;
		hasUsedArrowKeys = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").length_squared() > 0;
	
	HintsController.make_hint("Hint: Use LEFT SHIFT key to sprint", 6, true);
	var clickedShiftKey = false;
	while not clickedShiftKey:
		await get_tree().process_frame;
		clickedShiftKey = Input.is_action_pressed("Sprint");
	
	currentCharacter.data.doneBasicTutorial = true;

func change_character(nextCharacter: CharacterController):
	var lastCharacter = currentCharacter;
	currentCharacter = nextCharacter;
	lastCharacter.data.wishSprint = false;

func get_scene_characters() -> Array[CharacterController]:
	var sceneChildren = currentScene.get_children();
	var characters: Array[CharacterController] = [];
	for item in sceneChildren:
		if item is CharacterController:
			characters.append(item);
	return characters;

func _process(delta: float) -> void:
	if not transitioning and wishTransitionScene:
		wishTransitionScene = false;
		change_scene_to(nextScene);

func _start_game() -> void:
	if gameStarted:
		return
	gameStarted = true
	
	currentScene = get_tree().current_scene;
	
	spawn_starter_character();
	currentCamera = currentScene.get_node("%Camera");
	currentCamera.position = currentCharacter.position;
	
	create_tween().tween_property(transition_panel, "modulate:a", 0, SCENE_CANMOVE_DELAY / 2);
	
	if currentScene.has_method("_scene_ready"):
		currentScene._scene_ready();

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("CharacterChange"):
		#var currentIndex = characterSnapshots.find(currentCharacter);
		#var nextIndex =  0 if currentIndex + 2 > characterSnapshots.size() else currentIndex + 1;
		#change_character(characterSnapshots.get(nextIndex));
