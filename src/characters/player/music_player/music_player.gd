class_name  MusicPlayer
extends AudioStreamPlayer

## single fade in or fade out
@export var fade_in_duration: float = 1
@export var fade_out_duration: float = 1
@export var volume: float = 0.0

const MIN_VOLUME = -20

var fade_tween = null
var interrupt: bool = false

#var is_waiting = false

func _ready() -> void:
	volume_db = MIN_VOLUME
	

func _process(delta: float) -> void:
	print(volume_db)
	
	
func set_soundtrack(soundtrack: AudioStream):
	sync_tweens()
	
	#await get_tree().process_frame
	
	if soundtrack == null:
		fade_out()
		return
	
	if soundtrack != self.stream:
		self.set_stream(soundtrack)
		self.play()
	
	fade_in()


#func reset_soundtrack():
	##while is_waiting:
		##await get_tree().create_timer(0.01).timeout
	#
	#if volume_db != MIN_VOLUME:
		#await fade_out()
	#self.stop()
	#self.set_stream(null)


func change_volume(value: float) -> void:
		volume_db = value


func fade_out(vol = MIN_VOLUME, duration = fade_out_duration) -> void:
	if volume_db == vol:
		return
	fade_tween = create_tween().bind_node(self)
	fade_tween.tween_method(change_volume, volume_db, MIN_VOLUME, duration)
	await fade_tween.finished


func fade_in() -> void:
	fade_tween = create_tween().bind_node(self)
	fade_tween.tween_method(change_volume, volume_db, volume, fade_in_duration)
	await fade_tween.finished


func sync_tweens():
	if fade_tween:
		fade_tween.kill()
		#fade_tween.free()
		fade_tween = null
