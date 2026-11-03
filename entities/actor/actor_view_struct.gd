class_name ActorViewStruct
extends Resource

var _removed_letters: Array[String] = []

func _init(removed_letters: Array[String]) -> void:
	_removed_letters.append_array(removed_letters)
