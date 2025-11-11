extends Node

@onready var user_interface: Control = UserInterface.get_node("user_interface");
@onready var hint_label: Label = user_interface.get_node("hint");

var latest_id: int = 0;
var hint_queue: Array[Array] = [];

signal hint_completed(hint_id: int, overridden: bool);

func make_hint(hintText: String, displayTime: float, override: bool) -> int:
	var hint_id: int = latest_id;
	latest_id += 1
	if override and hint_queue.size() > 0:
		var latest_hint = hint_queue[0];
		var latest_hint_id: int = latest_hint[2];
		emit_signal("hint_completed", latest_hint_id, true);
		hint_queue[0] = [hintText, displayTime, hint_id];
	else:
		hint_queue.append([hintText, displayTime, hint_id]);
	return hint_id
	

func _process(delta: float) -> void:
	if hint_queue.size() > 0:
		var latest_hint: Array = hint_queue[0];
		var hintText: String = latest_hint[0];
		var displayTime: float = latest_hint[1];
		var hint_id: int = latest_hint[2];
		
		if displayTime > 0:
			hint_label.text = hintText;
			hint_label.modulate.a = clamp(displayTime, 0, 1);
			latest_hint[1] = clamp(displayTime - delta, 0, displayTime);
		else:
			hint_queue.pop_at(0);
			emit_signal("hint_completed", hint_id, false);
			print("completed " + str(hint_id))
		

func _ready() -> void:
	hint_label.text = "";
	hint_label.modulate.a = 0;
	pass;
