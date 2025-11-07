extends CharacterController;

@onready var stick_scene = preload("res://items/stick.tscn");

func throw_stick():
	var currentScene = get_tree().current_scene;
	
	var stick = stick_scene.instantiate()
	stick.name = "stick";
	currentScene.add_child(stick)
	stick.global_position = global_position
	
	var dir = (get_global_mouse_position() - global_position).normalized()
	stick.throw_stick(dir)
	
	PlayerController.change_character(currentScene.get_node("usman"));

func _physics_process(delta: float) -> void:
	if data.isPlayer:
		data.wishDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	else:
		data.wishDirection = Vector2.ZERO;
	super._physics_process(delta);

func _input(event: InputEvent) -> void:
	var currentScene = get_tree().current_scene
	if event.is_action_pressed("ThrowStick") and data.hasStick and currentScene.name == "outside":
		data.hasStick = false;
		throw_stick();
		
