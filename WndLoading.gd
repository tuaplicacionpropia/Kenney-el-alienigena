extends Control

export var numLoops = -1
var loopIdx = 0

func _ready():
	self.loopIdx = 0
	pass

func waitStart ():
	var timer = Timer.new()
	timer.connect("timeout", self, "startProgress", [timer])
	timer.set_wait_time(5.0)
	timer.start()
	self.add_child(timer)
	
func startProgress (timer):
	$wnd/anim.play("loading")
	self.remove_child(timer)
	#autoplay = "spin"
	#$wnd/anim.play()

func _physics_process(delta):
	if self.numLoops < 0:
		if not $wnd/anim.is_playing():
			$wnd/anim.play("loading")
	else:
		if not $wnd/anim.is_playing():
			if self.loopIdx < numLoops:
				self.loopIdx += 1
				$wnd/anim.play("loading")
