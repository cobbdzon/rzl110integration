extends CharacterController;

@onready var detect_area = $Area2D

func update_anims(delta: float) -> void:
	super.update_anims(delta);
	if velocity.length() > 60 and chosenAnimDir == "side":
		chosenAnimState = "run";

func _on_body_entered(body: Node):
	if body.name == "stick":
		data.hasStick = true;
		body.queue_free()
	elif body.name == "rizal":
		if data.hasStick:
			var rizal: CharacterController = get_tree().current_scene.get_node("rizal");
			PlayerController.change_character(rizal);
			rizal.data.canMove = false;
			get_tree().create_timer(0.5).timeout.connect(func():
				rizal.data.canMove = true;
				data.hasStick = false;
				rizal.data.hasStick = true;
			)

func _ready() -> void:
	detect_area.body_entered.connect(_on_body_entered);

func _physics_process(delta: float) -> void:
	if data.isPlayer:
		data.wishDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	else:
		data.wishDirection = Vector2.ZERO;
	super._physics_process(delta);
