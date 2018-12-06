# Custom camera
extends Node

#onready var screen_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
#onready var player = get_node("Player")
var player = null
var last_player_pos = null

func _ready():
	var screen_size = get_viewport().size
	self.player = self.get_node("Player")
	self.last_player_pos = self.player.position
	var canvas_transform = get_viewport().get_canvas_transform()
	canvas_transform[2] = self.player.position - screen_size / 2
	get_viewport().set_canvas_transform(canvas_transform)


func update_camera(jugador):
	if self.player.previousParent == null:
		var player_offset = self.last_player_pos - self.player.position
		self.last_player_pos = self.player.position

		var canvas_transform = get_viewport().get_canvas_transform()
		canvas_transform[2] += player_offset
		get_viewport().set_canvas_transform(canvas_transform)	
		print('moved!')
