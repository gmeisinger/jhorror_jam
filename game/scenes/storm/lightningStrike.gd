extends Node2D

signal LightningStrike(global_position)

export var lightning_bolt_length : float = 600.0
export var lightning_bolt_segment_generations : int = 7
export var max_lightning_bolt_segment_offset : float = 100.0
export var show_position : bool
export var visible_lightning : bool

class Segment:
	var start : Vector2 = Vector2.ZERO
	var end : Vector2 = Vector2.DOWN
	func _init(start : Vector2, end : Vector2):
		self.start = start
		self.end = end
	func split(offset : float) -> Array:
		var mid_point = lerp(start, end, .5)
		#mid += (direction.normalized() * rand_range(-offset,offset)).tangent()
		mid_point += (end - start).normalized().tangent()*rand_range(-offset,offset)
		return [Segment.new(start, mid_point), Segment.new(mid_point, end)]


class SegmentGenerator:
	func generate_segments(start: Vector2, end: Vector2, generations: int, max_offset: float) -> Array:
		var offset = max_offset
		var segments = [Segment.new(start, end)]
		for i in range(generations):
			for j in range(segments.size()):
				var segment = segments.pop_front()
				var new_segments = segment.split(offset)
				segments.push_back(new_segments[0])
				segments.push_back(new_segments[1])
			offset = offset / 2
		return segments
	func generate_vector_array(start: Vector2, end: Vector2, generations: int, max_offset: float) -> PoolVector2Array:
		var segments = generate_segments(start, end, generations, max_offset)
		var pool_vector_array = PoolVector2Array()
		for segment in segments:
			pool_vector_array.append(segment.start)
		pool_vector_array.append(segments[segments.size() - 1].end)
		return pool_vector_array

func _ready():
	SignalMgr.register_publisher(self, "LightningStrike")
	#$icon.visible = show_position
	call_deferred("init")

func init():
	emit_signal("LightningStrike", global_position * 2.0)
	_on_VisibilityNotifier2D_screen_entered()
	

func _on_AudioStreamPlayer2D_finished():
	call_deferred("queue_free")


func _on_lightningLineTimer_timeout():
	$lightningLine.visible = false


func _on_VisibilityNotifier2D_screen_entered():
	if !visible_lightning:
		return
	var end = global_position
	var start = end + Vector2(0.0, -lightning_bolt_length)
	print("lightning strike start = " + str(start) + ", end = " + str(end))
	var segmentGenerator = SegmentGenerator.new()
	$lightningLine.points = segmentGenerator.generate_vector_array(start, end, lightning_bolt_segment_generations, max_lightning_bolt_segment_offset)
	$lightningLine.visible = true
	$lightningLineTimer.start()
