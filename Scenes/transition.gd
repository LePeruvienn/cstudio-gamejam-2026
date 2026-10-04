extends TextureRect
class_name Transition

@export var transition_duration: float = 1.5
@export var mid_duration: float = 1.5
@export var transition_sfx: AudioStream

@onready var audio_node: AudioStreamPlayer = $AudioStreamPlayer

var is_making_transition := false
var timer := 0.0
var current_callback: Callable
var callback_called := false

func _ready() -> void:
	modulate.a = 0.0
	hide()
	audio_node.stream = transition_sfx


func _process(delta: float) -> void:
	if not is_making_transition:
		return

	timer += delta

	var fade_in_end := transition_duration
	var fade_out_start := transition_duration + mid_duration
	var transition_end := fade_out_start + transition_duration

	# Fade IN
	if timer < fade_in_end:
		modulate.a = timer / transition_duration
		return

	# Écran complètement noir
	modulate.a = 1.0

	# Appel du callback une seule fois
	if not callback_called:
		callback_called = true

		if transition_sfx:
			audio_node.play()

		if current_callback.is_valid():
			current_callback.call()

	# Pause au noir
	if timer < fade_out_start:
		return

	# Fade OUT
	var fade_out_timer := timer - fade_out_start
	modulate.a = 1.0 - (fade_out_timer / transition_duration)

	# Fin
	if timer >= transition_end:
		modulate.a = 0.0
		is_making_transition = false
		timer = 0.0
		callback_called = false
		hide()


func make_transition(callback: Callable) -> void:
	if is_making_transition:
		return

	show()

	timer = 0.0
	current_callback = callback
	callback_called = false
	is_making_transition = true
	modulate.a = 0.0


func debug_test() -> void:
	print("CALLBACK !!")
