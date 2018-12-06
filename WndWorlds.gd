extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var options = []
export var pageIdx = 0

signal click
signal home

const SELECTED = preload("res://assets/ui/radio_selected.png")
const UNSELECTED = preload("res://assets/ui/radio_unselected.png")

func _ready():
	#self.options = []
	#self.options.append({"lock": false, "logo": "world2", "numStars": 3})
	#self.options.append({"lock": true, "logo": "world1", "numStars": -2})
	$wnd/btnPrevious.connect("pressed", self, "_on_btnPrevious_pressed")
	$wnd/btnNext.connect("pressed", self, "_on_btnNext_pressed")
	self.showPage()
	#$wnd/level1.connect("click", self, "fnOpenLevel")
	#$wnd/level2.connect("click", self, "fnOpenLevel")
	#$wnd/level3.connect("click", self, "fnOpenLevel")
	#$wnd/level4.connect("click", self, "fnOpenLevel")
	#$wnd/level5.connect("click", self, "fnOpenLevel")
	#$wnd/level6.connect("click", self, "fnOpenLevel")
	#$wnd/level7.connect("click", self, "fnOpenLevel")
	#$wnd/level8.connect("click", self, "fnOpenLevel")
	#$wnd/level9.connect("click", self, "fnOpenLevel")

func showPage ():
	if self.options != null and self.options.size() > 0 and self.pageIdx >= 0:
		if self.pageIdx == 0:
			$wnd/btnPrevious.set_normal_texture(load("res://assets/ui/btn_home.png"))
		else:
			$wnd/btnPrevious.set_normal_texture(load("res://assets/ui/btn_previous.png"))

		var numOptions = self.options.size()
		var option = self.options[self.pageIdx]
		
		
		#var logoImgPath = "res://assets/worlds/" + option.logo + ".png"
		var logoImgPath = option.logo
		#"res://assets/worlds/world2.png"
		var lock = option.data.lock
		var numStars = option.data.numStars
		
		var logoImg = load(logoImgPath)
		$wnd/SelectWorld/logo.set_texture(logoImg)
		
		if lock:
			$wnd/SelectWorld/btn.set_texture(load("res://assets/ui/icon_lock.png"))
		else:
			$wnd/SelectWorld/btn.set_texture(load("res://assets/ui/btn_play.png"))

		var starsPath = null
		starsPath = "res://assets/ui/stars_zero.png" if numStars == 0 else starsPath
		starsPath = "res://assets/ui/stars_one.png" if numStars == 1 else starsPath
		starsPath = "res://assets/ui/stars_two.png" if numStars == 2 else starsPath
		starsPath = "res://assets/ui/stars_three.png" if numStars == 3 else starsPath
		if starsPath != null:
			$wnd/stars.show()
			$wnd/stars.set_texture(load(starsPath))
		else:
			$wnd/stars.hide()
		
		self.updateRadios()

func get_minimum_size():
    return Vector2(1240, 1528)

func updateRadios ():
	if self.pageIdx == 0:
		$wnd/page1.set_texture(SELECTED)
		$wnd/page2.set_texture(UNSELECTED)
		$wnd/page3.set_texture(UNSELECTED)
	elif self.pageIdx == (self.options.size() - 1):
		$wnd/page1.set_texture(UNSELECTED)
		$wnd/page2.set_texture(UNSELECTED)
		$wnd/page3.set_texture(SELECTED)
	else:
		$wnd/page1.set_texture(UNSELECTED)
		$wnd/page2.set_texture(SELECTED)
		$wnd/page3.set_texture(UNSELECTED)

func fnOpenLevel (option, ui):
	var app = get_node("/root/App")
	app.playSound(app.SOUND_CLICK)
	print("select level " + str(option))
	emit_signal("openLevel", option, ui)


func _on_btnPrevious_pressed():
	var app = get_node("/root/App")
	app.playSound(app.SOUND_CLICK)
	if self.pageIdx > 0:
		self.pageIdx -= 1
		self.showPage()
	else:
		emit_signal("home", self)
	#print("previous")

const SOUND_CLICK = preload("res://assets/sounds/click.ogg")

func _on_btnNext_pressed():
	if (self.pageIdx + 1) < self.options.size():
		var app = get_node("/root/App")
		app.playSound(app.SOUND_CLICK)
		self.pageIdx += 1
		self.showPage()
	#print("next")


func _on_SelectWorld_input_event(viewport, event, shape_idx):
	if self.pageIdx < self.options.size():
		var option = self.options[self.pageIdx]
		if not option.data.lock:
			if event is InputEventMouseButton:
				if event.is_pressed() and event.button_index == BUTTON_LEFT:
					var app = get_node("/root/App")
					app.playSound(app.SOUND_CLICK)
					emit_signal("click", option, self)
					#else:
					#	emit_signal("click", self, self)
					#print("click " + self.labelName)
