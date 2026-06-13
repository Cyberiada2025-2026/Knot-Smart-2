class_name  MusicPlayer
extends AudioStreamPlayer

## single fade in or fade out
@export var fade_in_duration: float = 1
@export var fade_out_duration: float = 1
@export var volume: float = 0.0

const MIN_VOLUME = -40

var fade_tween = null
var areas_disabled = false

func set_soundtrack(soundtrack: AudioStream):
	sync_tweens()

	if soundtrack == null:
		fade_out()
		return

	if soundtrack != self.stream:
		var cross_player = self.duplicate()
		add_child(cross_player)
		cross_player.play(self.get_playback_position())
		cross_player.fade_and_die()

		self.volume_db = MIN_VOLUME
		self.set_stream(soundtrack)
		self.play()

	fade_in()


## disable music area interactions with this module
func disable_areas():
	areas_disabled = true


## enable music area interactions with this module
func enable_areas():
	areas_disabled = false


func _change_volume(value: float) -> void:
		volume_db = value


func fade_out() -> void:
	if volume_db == MIN_VOLUME:
		return
	fade_tween = create_tween().bind_node(self)
	fade_tween.tween_method(_change_volume, volume_db, MIN_VOLUME, fade_out_duration)
	await fade_tween.finished


func fade_in() -> void:
	fade_tween = create_tween().bind_node(self)
	fade_tween.tween_method(_change_volume, volume_db, volume, fade_in_duration)
	await fade_tween.finished


func sync_tweens():
	if fade_tween:
		fade_tween.kill()
		#fade_tween.free()
		fade_tween = null


func fade_and_die():
	await fade_out()
	self.queue_free()
