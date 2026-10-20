class_name ArrayWordValidator
extends BaseWordValidator

const _word_whitelist: Array[String] = [
	"words",
	"tests",
	"fooba",
	]

func is_word_valid(word: String) -> ValidationResponse:
	var is_valid = word.to_lower() in _word_whitelist
	var reason = "Word not contained in list" if not is_valid else ""
	return ValidationResponse.new(is_valid, reason)
