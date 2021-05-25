extends RigidBody2D

onready var ballgraphic = $TestBall
onready var cshape = $CShape
onready var bzone = $BulletZone

var iscale

func _ready():
	iscale = ballgraphic.scale
	pass

func _process(delta):
	ballgraphic.scale = lerp(ballgraphic.scale, iscale, delta*5)
	pass

func _on_BulletZone_area_entered(area):
	area.queue_free()
	iscale *= 1.1
	cshape.scale *= 1.1
	bzone.scale *= 1.1
	ballgraphic.scale *= 1.3
	if (iscale.x >= 1):
		queue_free()
