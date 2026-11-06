class_name ActorView
extends Control


@onready var removed_letter_label: Label = %RemovedLetterLabel
@onready var entered_letter_label: Label = %EnteredLettersLabel
@onready var actor: Actor = $Actor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	removed_letter_label.text = ""
	entered_letter_label.text = ""
	_register_callbacks()


func _register_callbacks() -> void:
	actor.letters_removed.connect(_on_letters_removed)
	actor.word_updated.connect(_on_word_updated)


func _on_letters_removed(letters: Array[String]) -> void:
	removed_letter_label.text = ", ".join(letters)


func _on_word_updated(word: String) -> void:
	entered_letter_label.text = word


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	var child = get_node_or_null("Actor")
	if child == null or child is not Actor:
		warnings.append('Child named "Actor" of type Actor must be added.')
	return warnings
