extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var numStars = 0
export var score = 0
export var bestScore = 0

signal home
signal nextLevel
signal menu

func _ready():
	var fileStars = "res://assets/ui/stars_zero.png"
	if self.numStars == 1:
		fileStars = "res://assets/ui/stars_one.png"
	elif self.numStars == 2:
		fileStars = "res://assets/ui/stars_two.png"
	elif self.numStars == 3:
		fileStars = "res://assets/ui/stars_three.png"
	var texture = load(fileStars)
	$wnd/stars.set_texture(texture)
	
	$wnd/score.set_text(str(self.score))
	$wnd/bestScore.set_text(str(self.bestScore))

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_btnHome_pressed():
	print("home")
	emit_signal("home", self)

func _on_btnPlay_pressed():
	print("play")
	emit_signal("nextLevel", self)

func _on_btnMenu_pressed():
	print("menu")
	emit_signal("menu", self)
