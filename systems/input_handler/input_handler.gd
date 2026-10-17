class_name InputHandler
extends Node

signal letter_received(letter: String)
signal submit_received()

func _input(event: InputEvent) -> void:
	if event is not InputEventKey or not event.is_pressed():
		return

	process_event_key(event)

func process_event_key(event_key: InputEventKey) -> void:
	if event_key.keycode == Key.KEY_ENTER:
		submit_received.emit()
		return
	if event_key.keycode not in range(Key.KEY_A, Key.KEY_Z + 1):
		print_debug("Not a letter key")
		return
	
	var letter := event_key.as_text()
	print_debug(letter, " was pressed!")
	letter_received.emit(letter)
