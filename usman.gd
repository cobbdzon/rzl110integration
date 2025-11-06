extends CharacterController;

func update_anims(delta: float) -> void:
	super.update_anims(delta);
	if velocity.length() > 60 and chosenAnimDir == "side":
		chosenAnimState = "run";

func _physics_process(delta: float) -> void:
	if data.isPlayer:
		data.wishDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	else:
		data.wishDirection = Vector2.ZERO;
	super._physics_process(delta);
