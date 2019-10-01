extends Node2D

export var walk_speed = 25
export var y_start = 65
export var y_end = 280

func _ready():
	call_deferred("init")

func init():
	$SarahSWalkSprite.global_position = Vector2(200, y_start)
	$SWalkSprite01.global_position = Vector2(240, y_start)
	$TomSWalkSprite.global_position = Vector2(280, y_start)

func _process(delta):
	var y_delta = walk_speed * delta
	var y = $SarahSWalkSprite.global_position.y
	y += y_delta
	if y >= y_end:
		y = y_start
	$SarahSWalkSprite.global_position = Vector2(200,y)
	$SWalkSprite01.global_position = Vector2(240, y)
	$TomSWalkSprite.global_position = Vector2(280,y)

func _on_Timer_timeout():
	var frame = $SarahSWalkSprite.frame
	frame = (frame + 1 ) % $SarahSWalkSprite.hframes
	$SarahSWalkSprite.frame = frame
	$TomSWalkSprite.frame = frame
	$MothSprite002.frame = frame
	frame = $SWalkSprite01.frame
	frame = (frame + 1 ) % $SWalkSprite01.hframes
	$SWalkSprite01.frame = frame


