extends RigidBody2D

export(int) var graphic_pixel_size
export(bool) var does_explode
export(float) var speed_min
export(float) var speed_max
export(int) var point_value

export(Vector2) var pop_cloud_size
export(float) var pop_cloud_duration
export(float) var pop_cloud_speed
export(Vector2) var pop_bang_size

onready var ballgraphic = $TestBall
onready var cshape = $CShape
onready var inflatesound = $InflateSound
onready var bzone = get_node("BulletZone/CollisionShape2D")
var iscale = Vector2.ZERO

onready var pop_object = preload("res://Balls/Small_popsprite.tscn")
onready var pop_cloud = preload("res://Balls/CloudSprite.tscn")

func _ready():
	call_deferred("set_me_up")
	
func set_me_up():
	linear_velocity.x = rand_range(-200, 200)
	linear_velocity.y = 100
	iscale = ballgraphic.scale
	cshape.scale = ballgraphic.scale
	bzone.scale = ballgraphic.scale

func _physics_process(delta):
	var realsize = (graphic_pixel_size*ballgraphic.scale.x)/2
	if (transform.origin.x < -realsize):
		transform.origin.x = 256 + realsize - 2
	if (transform.origin.x > 256 + realsize):
		transform.origin.x = -realsize + 2
	angular_velocity = 0
	ballgraphic.scale = lerp(ballgraphic.scale, iscale, delta*6)
	if (linear_velocity.length() < speed_min):
		linear_velocity *= 1.1
	elif (linear_velocity.length() > speed_max):
		linear_velocity *= 0.9
	#To keep it from getting stuck in the top
	if (transform.origin.y < 8):
		linear_velocity.y = 70

func _on_BulletZone_area_entered(area):
	inflatesound.play()
	inflatesound.pitch_scale += 0.1
	if (transform.origin.distance_squared_to(Vector2(ScoreTracker.player_last_x, ScoreTracker.player_last_y)) < 1000):
		ScoreTracker.increase_score(15)
	else:
		ScoreTracker.increase_score(10)
	area.queue_free()
	linear_velocity *= 0.6
	linear_velocity += area.vel.rotated(area.rot) * 15
	iscale += Vector2.ONE * 0.1
	cshape.scale += Vector2.ONE * 0.1
	bzone.scale += Vector2.ONE * 0.1
	ballgraphic.scale *= 1.3
	if (iscale.x >= 0.8):
		onpop()
		if (does_explode):
			starexplode()


func _on_TestBall_body_entered(body):
	ballgraphic.scale *= 1.05
	linear_velocity *= 1.2
	
func starexplode():
	for i in get_parent().get_children():
		if i.has_method("react_to_star_explode"):
			i.react_to_star_explode()
			
func react_to_star_explode():
	onpop()

func onpop():
	ScoreTracker.playExplodeSound()
	ScoreTracker.pop_check(self)
	ScoreTracker.increase_score(100)
	var x = pop_object.instance()
	x.transform.origin = transform.origin
	x.angle(Vector2.ZERO, 0, 15, pop_bang_size)
	get_parent().add_child(x)
	for i in range(6):
		var newcloud = pop_cloud.instance()
		newcloud.transform.origin = transform.origin
		newcloud.angle(
			Vector2.RIGHT*pop_cloud_speed, 
			i*45, 
			pop_cloud_duration, 
			pop_cloud_size
		)
		get_parent().add_child(newcloud)
	queue_free()
