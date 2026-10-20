class_name BaseWordValidator
extends Object

class ValidationResponse:
	var is_valid: bool
	var reason: String
	
	func _init(is_valid: bool, reason: String) -> void:
		self.is_valid = is_valid
		self.reason = reason

func is_word_valid(word: String) -> ValidationResponse:
	return ValidationResponse.new(true, "")
