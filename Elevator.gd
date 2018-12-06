tool
extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var positionInitial = null
var flagDirection = true
export var vertical = true
export var speed = 0.5
export var amplitude = 300

func _ready():
	self.positionInitial = self.position
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	if not Engine.editor_hint:
		var diff = abs(self.position.y - self.positionInitial.y) if self.vertical else abs(self.position.x - self.positionInitial.x)
		flagDirection = not flagDirection if diff > self.amplitude else flagDirection
		
		var direction = -self.speed if flagDirection else self.speed
		var translate = Vector2(0, direction) if self.vertical else Vector2(direction, 0)
		self.translate(translate)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _draw():
	if Engine.editor_hint:
		#draw_line(Vector2(0,0), Vector2(100, 100), Color('#ffffff'), 2.0)
		var color = Color('#ffffff')
		if not self.vertical:
			draw_line(Vector2(0, 0), Vector2(- self.amplitude, 0), color, 10.0)
			draw_line(Vector2(0, 0), Vector2(self.amplitude, 0), color, 10.0)
		else:
			draw_line(Vector2(0, 0), Vector2(0, - self.amplitude), color, 10.0)
			draw_line(Vector2(0, 0), Vector2(0, self.amplitude), color, 10.0)
