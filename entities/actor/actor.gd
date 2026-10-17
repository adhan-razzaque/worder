class_name Actor
extends Node2D

@onready var input_handler: InputHandler = $InputHandler
@onready var word_validator: BaseWordValidator = ArrayWordValidator.new()

# TODO: Consider switching to PackedStringArray
var letter_list: Array[String] = []
const max_letters: int = 5

func _ready() -> void:
	input_handler.letter_received.connect(on_letter_received)
	input_handler.submit_received.connect(on_submit_received)


func on_letter_received(letter: String) -> void:
	print_debug("Actor received ", letter)

	if len(letter_list) == max_letters:
		letter_list.pop_front()
	letter_list.push_back(letter)
	
	print_debug("Current word: ", get_current_word())


func on_submit_received() -> void:
	print_debug("Actor received enter")
	if len(letter_list) != max_letters:
		print_debug("Enter rejected, not enough letters")
	
	var word: String = get_current_word()
	var word_is_valid = word_validator.is_word_valid(word)
	print_debug("Submitted word ", word, " is valid: ", word_is_valid)


func get_current_word() -> String:
	return "".join(letter_list)
