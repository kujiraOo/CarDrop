
Music = {}


function Music.load()
	Music.tracks = {}
	
	for i = 1, 5 do
		Music.tracks[i] = {track = Sound.new("sound/track"..i..".mp3")}
	end
	
	Music.tracks[1].mkey = 'c'
	Music.tracks[2].mkey = 'c#'
	Music.tracks[3].mkey = 'c'
	Music.tracks[4].mkey = 'c'
	Music.tracks[5].mkey = 'c'
end

function Music.init()
	Music.track_id = math.random(1, #Music.tracks)
	
	print("Music track number is :", Music.track_id)
	
	Music.channel = Music.tracks[Music.track_id].track:play(0, false)
	
	if SOUND_ON then
		Music.channel:setVolume(1)
	else
		Music.channel:setVolume(0)
	end
	
	
	Music.channel:addEventListener(Event.COMPLETE, Music.track_selection)
end


local function change_to_track(n)
	Music.channel = Music.tracks[n].track:play(0)
	Music.track_id = n
	Music.channel:addEventListener(Event.COMPLETE, Music.track_selection)
	
	if SOUND_ON then
		Music.channel:setVolume(1)
	else
		Music.channel:setVolume(0)
	end
end

-- меняет трек на любой случайный кроме текущего
function Music.track_selection()

	
	local new_track = General.random_el(Music.tracks, Music.track_id)
	change_to_track(new_track)
end


