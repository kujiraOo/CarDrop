Sfx = {}

local function load_sfx(type)
	Sfx[type] = {}
	
	Sfx[type]['c']  = Sound.new("sound/"..type.."/c.wav")
	Sfx[type]['c#'] = Sound.new("sound/"..type.."/c#.wav")
	
end

function Sfx.load()
	load_sfx("fanfare")
	load_sfx("rain")
	load_sfx("ufo")
end

function Sfx.play(type)
	if SOUND_ON then
		
		local mkey = Music.tracks[Music.track_id].mkey
		
		Sfx[type][mkey]:play()
	end
end