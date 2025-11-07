extends CharacterController;

@onready var detect_area = $Area2D

func _on_body_entered(body: Node):
	if body.name == "rizal":
		var rizal: CharacterController = get_tree().current_scene.get_node("rizal");
		print("farted")

func _ready() -> void:
	detect_area.body_entered.connect(_on_body_entered);

func _physics_process(delta: float) -> void:
	super._physics_process(delta);
