class_name ArrayWordValidator
extends BaseWordValidator

const _word_whitelist: Array[String] = [
	"words",
	"tests",
	"fooba",
	]

func is_word_valid(word: String) -> bool:
	return word.to_lower() in _word_whitelist
