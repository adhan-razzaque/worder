class_name BaseWordValidator
extends Object

class ValidationResponse:
	var is_valid: bool
	var reason: String
	
	func _init(is_valid: bool, reason: String) -> void:
		self.is_valid = is_valid
		self.reason = reason

var _tracked_words: Array[String] = []

func _init() -> void:
	reset()
	
func reset() -> void:
	_tracked_words.clear()

func is_word_valid(word: String) -> ValidationResponse:
	if is_reused_word(word):
		return ValidationResponse.new(false, "%s has been used before!" % word)
	return ValidationResponse.new(true, "")
	
func track_word(word: String) -> void:
	_tracked_words.append(word)

func is_reused_word(word: String) -> bool:
	return word in _tracked_words
