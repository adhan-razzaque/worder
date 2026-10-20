class_name ArrayWordValidator
extends BaseWordValidator

const _word_whitelist: Array[String] = [
	"words",
	"tests",
	"fooba",
	]

func is_word_valid(word: String) -> ValidationResponse:
	if is_reused_word(word):
		return ValidationResponse.new(false, "%s has been used before!" % word)
	var is_valid = word.to_lower() in _word_whitelist
	var reason = "Word not contained in list" if not is_valid else ""
	return ValidationResponse.new(is_valid, reason)
