tool
extends StaticBody2D

enum EnemyType { BARNACLE, BEE, FISH_BLUE, FISH_GREEN, FISH_PINK, 
FLY, FROG, LADYBUG, MOUSE, SAW, SAW_HALF
SLIME_BLOCK, SLIME_BLUE, SLIME_GREEN, SLIME_PURPLE, 
SNAIL, WORM_GREEN, WORM_PINK, SPIDER }

const ANIM_BARNACLE = {"name":"barnacle", "hit":false}
const ANIM_BEE = {"name":"bee", "hit":true}
const ANIM_FISH_BLUE = {"name":"fishBlue", "hit":true}
const ANIM_FISH_GREEN = {"name":"fishGreen", "hit":true}
const ANIM_FISH_PINK = {"name":"fishPink", "hit":true}
const ANIM_FLY = {"name":"fly", "hit":true}
const ANIM_FROG = {"name":"frog", "hit":true}
const ANIM_LADYBUG = {"name":"ladybug", "hit":true}
const ANIM_MOUSE = {"name":"mouse", "hit":true}
const ANIM_SAW = {"name":"saw", "hit":false}
const ANIM_SAW_HALF = {"name":"sawHalf", "hit":false}
const ANIM_SLIME_BLOCK = {"name":"slimeBlock", "hit":true}
const ANIM_SLIME_BLUE = {"name":"slimeBlue", "hit":true}
const ANIM_SLIME_GREEN = {"name":"slimeGreen", "hit":true}
const ANIM_SLIME_PURPLE = {"name":"slimePurple", "hit":true}
const ANIM_SNAIL = {"name":"snail", "hit":true}
const ANIM_WORM_GREEN = {"name":"wormGreen", "hit":true}
const ANIM_WORM_PINK = {"name":"wormPink", "hit":true}
const ANIM_SPIDER = {"name":"spider", "hit":true}

var ANIMS = {
	EnemyType.BARNACLE: ANIM_BARNACLE,
	EnemyType.BEE: ANIM_BEE,
	EnemyType.FISH_BLUE: ANIM_FISH_BLUE,
	EnemyType.FISH_GREEN: ANIM_FISH_GREEN,
	EnemyType.FISH_PINK: ANIM_FISH_PINK,
	EnemyType.FLY: ANIM_FLY,
	EnemyType.FROG: ANIM_FROG,
	EnemyType.LADYBUG: ANIM_LADYBUG,
	EnemyType.MOUSE: ANIM_MOUSE,
	EnemyType.SAW: ANIM_SAW,
	EnemyType.SAW_HALF: ANIM_SAW_HALF,
	EnemyType.SLIME_BLOCK: ANIM_SLIME_BLOCK,
	EnemyType.SLIME_BLUE: ANIM_SLIME_BLUE,
	EnemyType.SLIME_GREEN: ANIM_SLIME_GREEN,
	EnemyType.SLIME_PURPLE: ANIM_SLIME_PURPLE,
	EnemyType.SNAIL: ANIM_SNAIL,
	EnemyType.WORM_GREEN: ANIM_WORM_GREEN,
	EnemyType.WORM_PINK: ANIM_WORM_PINK,
	EnemyType.SPIDER: ANIM_SPIDER
}


var positionInitial = null
var flagDirection = true
export var vertical = true
export var speed = 0.5
export var amplitude = 300

export(EnemyType) var type = EnemyType.FLY



var dead = false

func _ready():
	self._updateAnimMove()
	self.dead = false
	self.positionInitial = self.position

func _updateAnimMove ():
	$sprite.play(ANIMS[self.type]['name'])

func _on_Enemy_body_entered(body):
	if body.get_name() == "Player":
		body.hitEnemy(self)
	pass # replace with function body

func _physics_process(delta):
	if not Engine.editor_hint and not self.dead:
		var diff = abs(self.position.y - self.positionInitial.y) if self.vertical else abs(self.position.x - self.positionInitial.x)
		flagDirection = not flagDirection if diff > self.amplitude else flagDirection
		
		var direction = -self.speed if flagDirection else self.speed
		if not self.vertical:
			$sprite.set_flip_h(not flagDirection)
			$shape.set_scale(Vector2(1 if flagDirection else -1, 1))

		var translate = Vector2(0, direction) if self.vertical else Vector2(direction, 0)
		self.translate(translate)

func hit ():
	var result = false
	if not $anim.is_playing() or $anim.get_current_animation() != "die":
		if ANIMS[self.type]['hit']:
			self.dead = true
			print("HIT")
			$shape.set_disabled(true)
			$sprite.play(ANIMS[self.type]['name'] + "_dead")
			$anim.play("die")
			result = true
	return result

func dead ():
	self.queue_free()

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
