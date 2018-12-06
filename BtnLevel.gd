tool
extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var lock = false setget set_lock, get_lock
export var labelName = "45" setget set_labelName, get_labelName
export var numStars = -1 setget set_numStars, get_numStars
export var option = {} setget set_option, get_option

var ready = false

func set_lock(newValue):
	lock = newValue
	self.updateWidget()

func get_lock():
	return lock

func set_labelName(newValue):
	labelName = newValue
	self.updateWidget()

func get_labelName():
	return labelName

func set_numStars(newValue):
	numStars = newValue
	self.updateWidget()

func get_numStars():
	return numStars

func set_option(newValue):
	option = newValue

func get_option():
	return option

func _ready():
	self.ready = true
	self.updateWidget()



signal click

func updateWidget():
	if self.ready:
		if self.lock:
			$bg/lock.show()
			$bg/num.hide()
			$bg/stars.hide()
		else:
			$bg/lock.hide()
			$bg/num.show()
			$bg/stars.show()
		
		var fileStars = null
		if self.numStars == 1:
			fileStars = "res://assets/ui/stars_one.png"
		elif self.numStars == 2:
			fileStars = "res://assets/ui/stars_two.png"
		elif self.numStars == 3:
			fileStars = "res://assets/ui/stars_three.png"
		elif self.numStars == 0:
			fileStars = "res://assets/ui/stars_zero.png"
		if fileStars != null:
			var texture = load(fileStars)
			$bg/stars.set_texture(texture)
		else:
			$bg/stars.hide()
	
		if self.labelName != null:
			$bg/num.set_text(self.labelName)
		else:
			$bg/num.hide()


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_BtnLevel_input_event(viewport, event, shape_idx):
	print("CLICK " + str(self.option))
	if not self.lock:
		if event is InputEventMouseButton:
			if event.is_pressed() and event.button_index == BUTTON_LEFT:
				if self.option != null:
					emit_signal("click", self.option, self)
				#else:
				#	emit_signal("click", self, self)
				#print("click " + self.labelName)
