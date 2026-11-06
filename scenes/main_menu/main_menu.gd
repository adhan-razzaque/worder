class_name MainMenu
extends Control

@export_file_path("*.tscn")
var next_scene_path: String = "res://scenes/arena/arena.tscn"

@onready var start_button: Button = %StartButton
@onready var exit_button: Button = %ExitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed() -> void:
	print_debug("Main Menu received start press")
	get_tree().change_scene_to_file(next_scene_path)

func _on_exit_button_pressed() -> void:
	print_debug("Main Menu received exit press")
	get_tree().quit()

## Perform platform-specific logic like hiding buttons
func _check_platform() -> void:
	var platform_name: String = OS.get_name()
	
	if platform_name not in ["Android", "iOS", "Web"]:
		return
	
	exit_button.visible = false
