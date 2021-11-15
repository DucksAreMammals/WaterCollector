extends Node2D

export (AudioStream) var drop_sound
export (AudioStream) var click_sound
export (AudioStream) var shoot_sound
export (AudioStream) var enemy_hit_sound
export (AudioStream) var player_hit_sound

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


func _play(player, sound, pitch_scale = true):
	if sfx_level > sfx_min:
		player.volume_db = sfx_level
		player.stream = sound
		
		if pitch_scale:
			player.pitch_scale = rand_range(0.9, 1.1)
		
		player.play()

func play_drop():
	_play($DropPlayer, drop_sound)

func play_click():
	_play($ClickPlayer, click_sound)

func play_shoot():
	_play($ShootPlayer, shoot_sound)

func play_enemy_hit():
	_play($EnemyHitPlayer, enemy_hit_sound)

func play_player_hit():
	_play($PlayerHitPlayer, player_hit_sound)
