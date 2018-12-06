extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var options = []
export var pageIdx = 0

signal openLevel
signal home

const SELECTED = preload("res://assets/ui/radio_selected.png")
const UNSELECTED = preload("res://assets/ui/radio_unselected.png")

func _ready():
	#self.options = []
	#self.options.append({"lock": false, "labelName": "P1", "numStars": 3})
	#self.options.append({"lock": false, "labelName": "P2", "numStars": 2})
	for wLevel in $wnd/levels.get_children():
		wLevel.connect("click", self, "fnOpenLevel")
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
	if self.options != null and self.pageIdx >= 0:
		if self.pageIdx == 0:
			$wnd/btnPrevious.set_normal_texture(load("res://assets/ui/btn_home.png"))
		else:
			$wnd/btnPrevious.set_normal_texture(load("res://assets/ui/btn_previous.png"))

		var numOptions = self.options.size()
		var firstIdx = self.pageIdx * 9
		var endIdx = firstIdx + (9 - 1)
		var wLevels = $wnd/levels.get_children()
		var idx = 0
		for i in range(firstIdx, (endIdx + 1)):
			if i >= numOptions:
				break
			var option = self.options[i]
			wLevels[idx].show()
			wLevels[idx].lock = option.data.lock
			wLevels[idx].labelName = option.labelName
			wLevels[idx].numStars = option.data.numStars
			wLevels[idx].option = option
			idx += 1
		if idx < 9:
			for i in range(idx, 9):
				wLevels[i].hide()
		self.updateRadios()

func get_minimum_size():
    return Vector2(1240, 1528)

func updateRadios ():
	if self.pageIdx == 0:
		$wnd/page1.set_texture(SELECTED)
		$wnd/page2.set_texture(UNSELECTED)
		$wnd/page3.set_texture(UNSELECTED)
	elif self.pageIdx == ceil(self.options.size() / 9):
		$wnd/page1.set_texture(UNSELECTED)
		$wnd/page2.set_texture(UNSELECTED)
		$wnd/page3.set_texture(SELECTED)
	else:
		$wnd/page1.set_texture(UNSELECTED)
		$wnd/page2.set_texture(SELECTED)
		$wnd/page3.set_texture(UNSELECTED)

func fnOpenLevel (option, ui):
	#print("select level " + str(option))
	emit_signal("openLevel", option, ui)
	#var app = get_node("/root/App")
	#app.playSound(app.SOUND_CLICK)


func _on_btnPrevious_pressed():
	var app = get_node("/root/App")
	app.playSound(app.SOUND_CLICK)
	if self.pageIdx > 0:
		self.pageIdx -= 1
		self.showPage()
	else:
		emit_signal("home", self)
	#print("previous")


func _on_btnNext_pressed():
	if ((self.pageIdx + 1) * 9) < self.options.size():
		var app = get_node("/root/App")
		app.playSound(app.SOUND_CLICK)
		self.pageIdx += 1
		self.showPage()
	#print("next")
