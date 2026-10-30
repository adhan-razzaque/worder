class_name Actor
extends Node2D

## Emitted when a letter is rejected, provides letter and a reason
signal rejected_letter(letter: String, reason: String)

## Emitted when a word is rejected, provides word and a reason
signal rejected_word(word: String, reason: String)

@export var start_lives: int = 3

@onready var input_handler: InputHandler = $InputHandler
@onready var word_validator: BaseWordValidator = ArrayWordValidator.new()

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
	
	if letter in _removed_letters:
		var reason: String = "Rejected letter because it's currently removed: %s" % letter
		print_debug(reason)
		rejected_letter.emit(letter, reason)
		print_debug("Current word: ", get_current_word())
		return

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

	var word: String = get_current_word()

	if len(letter_list) != max_letters:
		var reason: String = "Word rejected, not enough letters"
		print_debug(reason)
		rejected_word.emit(word, reason)
		return

	var response = word_validator.is_word_valid(word)
	print_debug("Submitted word ", word, " is valid: ", response.is_valid,
	" for reason: ", response.reason)

	if not response.is_valid:
		rejected_word.emit(word, response.reason)
		return

	word_validator.track_word(word)
	_removed_letters.append_array(letter_list)
	clear_word()

func get_current_word() -> String:
	return "".join(letter_list)

func clear_word() -> void:
	letter_list.clear()
	_index = 0

func set_index(new_index: int) -> void:
	new_index = min(new_index, len(letter_list))
	_index = new_index
	print_debug("New index: ", _index)
