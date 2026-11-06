class_name RoundDisplay
extends Control


@onready var round_label: Label = %RoundLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	round_label.text = ""
	_register_callbacks()


func _register_callbacks() -> void:
	GameManagerSingleton.round_started.connect(_on_round_started)


func _on_round_started(round: int) -> void:
	round_label.text = "%d" % round
