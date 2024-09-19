extends Button

var prev_pos_x
var prev_pos_y
@onready var camera: Camera2D = %Camera2D
@onready var main_music: AudioStreamPlayer2D = $"../../MainMusic"
@onready var dragon_sound: AudioStreamPlayer2D = $"../DragonSound"

var hand_cursor = preload("res://assets/cursors/hand_cursor.png")
var normal_cursor = preload("res://assets/cursors/normal_cursor.png")


func _ready():
	connect("pressed", move_to_dragon)
	
	connect("mouse_entered", change_cursor)
	connect("mouse_exited", reset_cursor)
	
func move_to_dragon():
	prev_pos_x = camera.global_position.x
	prev_pos_y = camera.global_position.y
	
	main_music.stop()
	dragon_sound.play()
	
	camera.position.x = -672
	camera.position.y = 459
	
	await get_tree().create_timer(8).timeout
	
	dragon_sound.stop()
	main_music.play()
	
	camera.position.x = prev_pos_x
	camera.position.y = prev_pos_y

func change_cursor():
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(6, 7))

func reset_cursor():
	Input.set_custom_mouse_cursor(normal_cursor, Input.CURSOR_ARROW, Vector2(5, 7))
