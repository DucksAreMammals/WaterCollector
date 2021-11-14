extends Node2D

export (AudioStream) var drop_sound
export (AudioStream) var click_sound

var music_min := -40.0

var sfx_level := 0.0
var sfx_min := -40.0

func update_volume():
	if Global.music_level > 0:
		$"/root/SoundHandler/MusicPlayer".volume_db = map_range(Global.music_level, 0, 100, music_min, 0)

		if not $"/root/SoundHandler/MusicPlayer".playing:
			$"/root/SoundHandler/MusicPlayer".playing = true
	else:
		$"/root/SoundHandler/MusicPlayer".playing = false
	
	sfx_level = map_range(Global.sfx_level, 0, 100, sfx_min, 0)
	

func map_range(value: float, in_a: float, in_b: float, out_a: float, out_b: float) -> float:
	return (value - in_a) / (in_b - in_a) * (out_b - out_a) + out_a


func play_drop():
	if sfx_level > sfx_min:
		$DropPlayer.volume_db = sfx_level
		$DropPlayer.stream = drop_sound
		$DropPlayer.play()

func play_click():
	if sfx_level > sfx_min:
		$ClickPlayer.volume_db = sfx_level
		$ClickPlayer.stream = click_sound
		$ClickPlayer.play()
