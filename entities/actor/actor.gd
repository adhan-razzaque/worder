class_name Actor
extends Node2D

@onready var input_handler: InputHandler = $InputHandler
@onready var word_validator: BaseWordValidator = ArrayWordValidator.new()

@export var start_lives: int = 3

const max_letters: int = 5

# TODO: Consider switching to PackedStringArray
var letter_list: Array[String]
var _current_lives: int
var _index: int
var _removed_letters: Array[String]

func _ready() -> void:
	_register_callbacks()
	_reset_state()

func _register_callbacks() -> void:
	input_handler.letter_received.connect(on_letter_received)
	input_handler.submit_received.connect(on_submit_received)

func _reset_state() -> void:
	_current_lives = start_lives
	letter_list = []
	_index = 0
	_removed_letters = []

func on_letter_received(letter: String) -> void:
	print_debug("Actor received ", letter)

	if _index == len(letter_list):
		if len(letter_list) == max_letters:
			letter_list.pop_front()
		else:
			_index += 1
		letter_list.push_back(letter)
	else:
		letter_list[_index] = letter
		_index += 1
	
	print_debug("Current word: ", get_current_word())


func on_submit_received() -> void:
	print_debug("Actor received enter")
	if len(letter_list) != max_letters:
		print_debug("Enter rejected, not enough letters")
	
	var word: String = get_current_word()
	var response = word_validator.is_word_valid(word)
	print_debug("Submitted word ", word, " is valid: ", response.is_valid,
	" for reason ", response.reason)
	if response.is_valid:
		word_validator.track_word(word)


func get_current_word() -> String:
	return "".join(letter_list)
	
func set_index(new_index: int) -> void:
	new_index = min(new_index, len(letter_list))
	_index = new_index
	print_debug("New index: ", _index)
