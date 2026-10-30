class_name GameManager
extends Node

signal player_registered(id: String)
signal player_unregistered(id: String)
signal round_started()
signal round_ended()

## Round length in seconds
@export var round_length_seconds: float = 30

## Maximum players accepted in this game
@export var max_players: int = 2

## Minimum players accepted in this game
@export var min_players: int = 2

enum RoundState {INPUT, INPUT_LOOP, RESOLUTION, ENDED, GAMEOVER}

var _current_round_state: RoundState = RoundState.GAMEOVER
var _round_number: int = 0
var _active_players: Dictionary[String, Actor] = {}
var _player_order: Array[String] = []
var _current_index: int = 0
var _player_submissions: Dictionary[String, String] = {}
@onready var _round_timer: Timer = $RoundTimer

func _process(_delta: float) -> void:
	if _current_round_state == RoundState.GAMEOVER:
		return
	elif _current_round_state == RoundState.ENDED:
		handle_ended_state()
	elif _current_round_state in [RoundState.INPUT, RoundState.INPUT_LOOP]:
		handle_input_state()
	elif _current_round_state == RoundState.RESOLUTION:
		handle_resolution_state()
	else:
		push_error("Unhandled RoundState ", _current_round_state)

func handle_input_state() -> void:
	var player_key: String = _player_order[_current_index]
	var player: Actor = _active_players[player_key]
	
	if _current_round_state == RoundState.INPUT:
		# Entry
		print_debug("Player ", player_key, " start!")
		player.set_active(true)
		_round_timer.start(round_length_seconds)
		_current_round_state = RoundState.INPUT_LOOP
		return
	
	# Loop
	if _round_timer.is_stopped():
		print_debug("Timed out!")
		player.set_active(false)
		_current_round_state = RoundState.RESOLUTION
		return
	
	if player_key not in _player_submissions:
		return
	
	_round_timer.stop()
	player.set_active(false)
	_current_round_state = RoundState.RESOLUTION

func handle_resolution_state() -> void:
	var player_key: String = _player_order[_current_index]
	var player: Actor = _active_players[player_key]

	if player_key not in _player_submissions:
		# Lose a life for not submitting
		player.lose_life()
	
	_current_index += 1
	
	if _current_index >= _active_players.size():
		end_round()
	else:
		_current_round_state = RoundState.INPUT

func handle_ended_state() -> void:
	for player_key in _player_submissions:
		_apply_letter_penalty(player_key)
	
	_player_submissions.clear()
	
	var player_lost: bool = _active_players.values().any(func(p: Actor) -> bool: return p.is_dead())
	
	if player_lost:
		_current_round_state = RoundState.GAMEOVER
	else:
		start_round()

func _apply_letter_penalty(submission_key: String) -> void:
	var word: String = _player_submissions[submission_key]
	var letters: PackedStringArray = word.split()
	
	for player_key in _active_players:
		if player_key == submission_key:
			continue
		
		var opponent: Actor = _active_players[player_key]
		
		if player_key not in _player_submissions:
			# Full penalty
			opponent.remove_letters(letters)
			continue
		
		var opponent_word: String = _player_submissions[player_key]
		var opponent_list: PackedStringArray = opponent_word.split()
		
		var result: Array[String] = []
		
		for letter in letters:
			if not opponent_list.has(letter):
				result.push_back(letter)
		
		print_debug("Penalty Result ", submission_key, " vs ", player_key, " ", result)
		opponent.remove_letters(result)

func submit_word(actor: Actor, word: String) -> bool:
	_player_submissions[actor.name] = word
	return true

func register_player(actor: Actor) -> bool:
	if _active_players.size() >= max_players:
		push_warning("Maximum players of ", max_players, " players reached.")
		return false
	
	var key: String = actor.name
	
	if key in _active_players:
		push_error("Player already registered: ", key)
		return false
	
	_active_players[key] = actor
	_player_order.push_back(key)
	player_registered.emit(key)
	print_debug("Registered ", key)
	return true

func unregister_player(actor: Actor) -> void:
	var key: String = actor.name
	
	if key not in _active_players:
		push_warning("Player already unregistereed: ", actor.name)
		return

	_active_players.erase(key)
	_player_order.erase(key)
	player_unregistered.emit(key)

func start_round() -> void:
	if _active_players.size() < min_players:
		push_warning("Rejected: ", _active_players.size(), " < ", min_players)
		return
	if _current_round_state not in [RoundState.GAMEOVER, RoundState.ENDED]:
		push_error("Game already in progress")
		return
	
	print_debug("Round ", _round_number, " is starting...")
	_current_index = 0
	round_started.emit()
	_current_round_state = RoundState.INPUT

func end_round() -> void:
	_round_number += 1
	_current_round_state = RoundState.ENDED
	round_ended.emit()
