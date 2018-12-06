extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal pause
signal finishLevel
signal fallPlayer
signal checkpoint
signal updateLifes

export var score = 0 setget set_score, get_score
export var stars = 0 setget set_stars, get_stars
export var lifes = 3 setget set_lifes, get_lifes

export var background = "res://assets/backgrounds/colored_desert.png" setget set_background, get_background

var ready = false

func set_lifes(newValue):
	lifes = newValue
	self.updateLifes()

func get_lifes():
	return lifes

func set_score(newValue):
	score = newValue
	self.updateWidget()

func get_score():
	return score

func set_stars(newValue):
	stars = newValue
	self.updateStars()

func get_stars():
	return stars

func set_background(newValue):
	background = newValue
	self.updateWidget()

func get_background():
	return background



func updateWidget ():
	if ready:
		$CanvasLayer/score.set_text(str(self.score))
		
		$ParallaxBackground/ParallaxLayer/Sprite.set_texture(load(self.background))

func updateLifes ():
	if ready:
		$CanvasLayer/hudLifes.set_amount(self.lifes)
		$Player.set_lifes(self.lifes)

func updateStars ():
	if ready:
		$CanvasLayer/hudStars.set_amount(self.stars)

#func add_child (node, legible_unique_name):
#	$Walls.add_child(node, legible_unique_name)

func _ready():
	self.ready = true
	$Player.connect("hurt", self, "updateLifesFromPlayer")
	self.updateWidget()
	self.updateLifes()
	self.updateStars()
	if false or OS.has_touchscreen_ui_hint():
		$CanvasLayer/touchLeft.show()
		$CanvasLayer/touchRight.show()
		$CanvasLayer/touchJump.show()
		$CanvasLayer/gui_pause/touchPause.show()
		$CanvasLayer/gui_pause/btnPause.hide()
	else:
		$CanvasLayer/touchLeft.hide()
		$CanvasLayer/touchRight.hide()
		$CanvasLayer/touchJump.hide()
		$CanvasLayer/gui_pause/touchPause.hide()
		$CanvasLayer/gui_pause/btnPause.show()

func updateLifesFromPlayer (player):
	self.set_lifes(player.get_lifes())
	emit_signal("updateLifes", self, player)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func _on_touchJump_pressed():
	var ev = InputEventAction.new()
	ev.set_action("ui_up")
	ev.set_pressed(true)
	Input.parse_input_event(ev)

func _on_touchJump_released():
	var ev = InputEventAction.new()
	ev.set_action("ui_up")
	ev.set_pressed(false)
	Input.parse_input_event(ev)

func _on_touchRight_pressed():
	var ev = InputEventAction.new()
	ev.set_action("ui_right")
	ev.set_pressed(true)
	Input.parse_input_event(ev)

func _on_touchRight_released():
	var ev = InputEventAction.new()
	ev.set_action("ui_right")
	ev.set_pressed(false)
	Input.parse_input_event(ev)

func _on_touchLeft_pressed():
	var ev = InputEventAction.new()
	ev.set_action("ui_left")
	ev.set_pressed(true)
	Input.parse_input_event(ev)

func _on_touchLeft_released():
	var ev = InputEventAction.new()
	ev.set_action("ui_left")
	ev.set_pressed(false)
	Input.parse_input_event(ev)



func _on_touchPause_pressed():
	self.clickPause()

func clickPause ():
	emit_signal("pause", self)

func _on_btnPause_pressed():
	self.clickPause()
