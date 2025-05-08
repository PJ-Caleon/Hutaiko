extends Sprite2D

@onready var falling_key = preload("res://Object/falling_key.tscn")
@export var key_name: String = ""

var falling_key_queue = []

var perfectPoint_threshold: float = 15
var ok_threshold: float = 75

var perfectScore: float = 100
var okScore: float = 20

var combo_multiplier: int = 1

func _ready():
	Signals.CreateFallingKey.connect(CreateFallingKey)
	$missSound.stream = load("res://Music/combobreak.mp3")
	$hitSound.stream = load("res://Music/osu-hit-sound.mp3")
	
func _process(delta):
	
	if Input.is_action_just_pressed(key_name):
		Signals.KeyListenerPress.emit(key_name, 0)
		$hitSound.play()
	
	# To pop objects out of screen
	if falling_key_queue.size() > 0:
		var front_key = falling_key_queue.front()
		if is_instance_valid(front_key):
			front_key.position.y += 1
			if front_key.position.y > get_viewport_rect().size.y:
				falling_key_queue.pop_front()

				# If player misses the key
				Signals.ResetCombo.emit()
				combo_multiplier = 1
				$missSound.play()

			# Input Keys
			if Input.is_action_just_pressed(key_name):
				var key_pop = falling_key_queue.pop_front()
				var distant_to_pass = abs(key_pop.pass_threshold - key_pop.global_position.y)	

				if distant_to_pass < perfectPoint_threshold:
					Signals.IncrementCombo.emit(true)
					combo_multiplier += 1
					$PerfectEffect.emitting = true
					Signals.IncrementScore.emit(perfectScore * combo_multiplier)
					$hitSound.play()
					key_pop.queue_free()

				elif distant_to_pass < ok_threshold:
					Signals.IncrementCombo.emit(true)
					combo_multiplier += 1
					$okEffect.emitting = true
					Signals.IncrementScore.emit(okScore * combo_multiplier)
					$hitSound.play()
					key_pop.queue_free()

				else:
					# Missed
					$missSound.play()
					Signals.IncrementScore.emit(0)
					Signals.ResetCombo.emit()
					combo_multiplier = 1
					key_pop.queue_free()
				key_pop.queue_free()

		else:
			falling_key_queue.pop_front()


# Calling of keys to fall down
func CreateFallingKey(button_name: String):
	if button_name == key_name:
		var funKey = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", funKey)
		funKey.Setup(position.x, frame)
		
		falling_key_queue.push_back(funKey)


func _on_spawn_timer_timeout():
	#CreateFallingKey()
	$SpawnTimer.wait_time = randf_range(0.1, 1)
	$SpawnTimer.start()
