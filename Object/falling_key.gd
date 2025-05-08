extends Sprite2D

@export var falling_speed: float = 700

var init_y_pos: float = -420
var has_passed: bool = false
var pass_threshold: float = 230

func _init():
	set_process(false)

func _process(delta):
	# Move the object downwards
	global_position += Vector2(0, falling_speed*delta)
	
	# Checks how long it takes for not to hit button
	if global_position.y > pass_threshold and not $Timer.is_stopped():
		print($Timer.wait_time - $Timer.time_left)
		$Timer.stop()
		has_passed = true

func Setup(target_x: float, target_frame: int):
	global_position = Vector2(target_x, init_y_pos)
	frame = target_frame
	set_process(true)

func _on_destory_timer_timeout():
	queue_free()
