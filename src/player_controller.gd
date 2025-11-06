extends Node;

signal scene_changed(new_scene: Node2D);

@export var starter_character_name: String = "rizal";
var currentCharacter: CharacterController;
var currentScene: Node2D;
var currentCamera: Camera2D;

var SCENE_CANMOVE_DELAY: float = 0.5;

# scene management
var nextScene: String = "outside";
var wishTransitionScene: bool = false;

var characterSnapshots: Dictionary[String, CharacterData];

func change_scene_to(scene: String):
	# save positions of non-characters
	#for character in get_scene_characters():
		#print(characterSnapshots);
		#character.data.scenePosition = character.global_position;
		#character.data.lastScene = currentScene.name;
		#characterSnapshots[character.name] = character.data;
	
	if currentCharacter:
		currentCharacter.data.lastScene = currentScene.name;
		currentCharacter.get_parent().remove_child(currentCharacter);
	
	# Change scene
	get_tree().change_scene_to_file("res://scenes/" + scene + ".tscn");
	await get_tree().process_frame;
	
	# load non-characters
	#for charName in characterSnapshots.keys():
		#var data: CharacterData = characterSnapshots[charName];
		#if data.lastScene == scene and not data.isPlayer:
			#var character_scene = load("res://characters/" + charName + ".tscn");
			#if character_scene:
				#var instance: CharacterController = character_scene.instantiate();
				#instance.data = data;
				##instance.load_data();
				#currentScene.add_child(instance);
	
	currentScene = get_tree().current_scene;
	emit_signal("scene_changed", currentScene);
	currentCamera = currentScene.get_node("%Camera")
	if currentCharacter:
		currentScene.add_child(currentCharacter);
		#currentCharacter.global_position = characterSnapshots[currentCharacter.name].scenePosition;
		currentCharacter.data.canMove = false;
		get_tree().create_timer(SCENE_CANMOVE_DELAY).timeout.connect(func ():
				currentCharacter.data.canMove = true;
		)
		currentCharacter.data.transitioningScene = false;

func _process(delta: float) -> void:
	if wishTransitionScene:
		change_scene_to(nextScene);
		wishTransitionScene = false;

func _ready() -> void:
	currentScene = get_tree().current_scene;
	spawn_starter_character();
	currentCamera = currentScene.get_node("%Camera");
	currentCamera.position = currentCharacter.position;

func spawn_starter_character() -> void:
	if starter_character_name == null:
		push_error("Starter character scene not set!")
		return

	var starter_character_scene: PackedScene = load("res://characters/" + starter_character_name + ".tscn");
	var instance: CharacterController = starter_character_scene.instantiate() as CharacterController;
	currentCharacter = instance;
	currentScene.add_child(currentCharacter);
	currentCharacter.global_position = Vector2(100, 300);
	print("spawned " + starter_character_name);
	
	currentCharacter.data.isPlayer = true

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
	

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("CharacterChange"):
		#var currentIndex = characterSnapshots.find(currentCharacter);
		#var nextIndex =  0 if currentIndex + 2 > characterSnapshots.size() else currentIndex + 1;
		#change_character(characterSnapshots.get(nextIndex));
