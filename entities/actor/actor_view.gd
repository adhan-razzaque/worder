class_name ActorView
extends Control


@onready var removed_letter_display: Label = %RemovedLetterLabel
@onready var actor: Actor = $Actor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	removed_letter_display.text = ""
	_register_callbacks()


func _register_callbacks() -> void:
	actor.actor_view_struct_changed.connect(_on_actor_view_struct_changed)


func _on_actor_view_struct_changed(actor_view_struct: ActorViewStruct) -> void:
	removed_letter_display.text = ", ".join(actor_view_struct._removed_letters)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	var child = get_node_or_null("Actor")
	if child == null or child is not Actor:
		warnings.append('Child named "Actor" of type Actor must be added.')
	return warnings
