extends TextureButton

var DRAGPREVIEW
signal flags_changed

var hand_cursor = preload("res://assets/cursors/hand_cursor.png")
var normal_cursor = preload("res://assets/cursors/normal_cursor.png")

func _ready():
	DRAGPREVIEW = preload("res://scenes/drag_preview.tscn")
	
	# for cursor change
	connect("mouse_entered", change_cursor)
	connect("mouse_exited", reset_cursor)
	
func change_cursor():
	Input.set_custom_mouse_cursor(hand_cursor, Input.CURSOR_ARROW, Vector2(6, 7))

func reset_cursor():
	Input.set_custom_mouse_cursor(normal_cursor, Input.CURSOR_ARROW, Vector2(5, 7))

# when starting to drag
func _get_drag_data(at_position: Vector2) -> Variant: 
	var slot = get_parent().get_name()
	
	var data = {}
	data["origin_node"] = self
	data["origin_slot"] = slot
	#data["origin_flag_ID"] = flagID
	data["origin_texture_normal"] = texture_normal
	data["origin_texture_pressed"] = texture_pressed
	data["origin_texture_hover"] = texture_hover
	
	var dragPreview = DRAGPREVIEW.instantiate()
	dragPreview.texture = texture_pressed
	add_child(dragPreview)
	
	return data
	
# when dragging and hovering over a potential slot
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var target_slot = get_parent().get_name()
	data["target_texture_normal"] = texture_normal
	data["target_texture_pressed"] = texture_pressed
	data["target_texture_hover"] = texture_hover
	#data["target_flag_ID"] = flagID
	
	return true # bc flags can be moved to any slot -> can later change
	
# when hovering over a valid slot
func _drop_data(at_position: Vector2, data: Variant) -> void:
	# switch sprites
	data["origin_node"].texture_normal = data["target_texture_normal"]
	data["origin_node"].texture_pressed = data["target_texture_pressed"]
	data["origin_node"].texture_hover = data["target_texture_hover"]
	
	texture_normal = data["origin_texture_normal"]
	texture_pressed = data["origin_texture_pressed"]
	texture_hover = data["origin_texture_hover"]
	
	emit_signal("flags_changed") # signal to box to check the order
	
	# add sound effect of switching flags later
