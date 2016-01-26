Game = {}

function Game.save()
	local file = io.open("|D|save.txt", "w")
	
	file:write(Game.day.."\n")
	file:write(Game.distance.."\n")
	file:write(Star.touched_count.."\n")
	file:write(tostring(SOUND_ON).."\n")
	file:write(Objects.current_set.."\n")
	file:write(Objects.next_distance.."\n")
	file:write(Upgrade.level)
	
	file:close()
end

function Game.load()
	local file = io.open("|D|save.txt")
	print (file)
	if file then
		Game.day = tonumber(file:read()) or 0
		Game.distance = tonumber(file:read()) or 0
		Star.touched_count = tonumber(file:read()) or 0
		
		local sound_on = file:read()
		
		if sound_on == "true" then
			SOUND_ON = true
			print ("SOUND IS ON")
		elseif sound_on == "false" then
			SOUND_ON = false
			print ("SOUND IS OFF")
		else
			SOUND_ON = true
			print ("BY DEFAULT SOUND IS ON")
		end
		
		Game.current_set = tonumber(file:read())
		
		print ("GAME CURRENT SET IS", Game.current_set)
		
		Game.next_distance = tonumber(file:read())
		Upgrade.level = tonumber(file:read()) or 0
		
		file:close()
	else
		Game.distance = 0
		Game.day = 0
		Star.touched_count = 0
		SOUND_ON = true
	end
end

function Game.load_data()
	--Objects.init_common()
	Main_pack = TexturePack.new("gfx/main.txt", "gfx/main.png")
	
	Passanger.loadTaxiTexturePack()
	
	Trees.load_textures()
	
	Music.load()
	Sfx.load()
end

function Game.start(debug_dice)

	if Startup_screen then
		stage:removeChild(Startup_screen)
	end
	
	if LOADING_ANIMATION then
		stage:removeChild(LOADING_ANIMATION)
		LOADING_ANIMATION = nil
	end
	
	Passanger.initSpawnTimer()
	
	Objects.init_starting_local_objects()
	
	Objects.spawn_init()
	Objects.initDescription()
	--SOUND_ON = false
	
	Music.init(true, 0.8)
	
	Car.init()
	Cloud.load()
	Road.init()
	Star.load()
	Sun.init()
	Trees.init()
	
	GUI.init()
	
	Sky = General.draw_rectangle(-100, APP_WIDTH + 100, -100, APP_HEIGHT, 0x96c8ff)
	Grass = General.draw_rectangle(-100, APP_WIDTH + 100, Car.layer.y - 20, APP_HEIGHT + 100, 0x50c850)
	
	-- для глюка с планшетом
	local road_bg = General.draw_rectangle(-100, APP_WIDTH + 100, Road.y, Road.y + 64, 0x929292) 

	
	Background = Sprite.new()
	Background:addChild(Grass)
	Background:addChild(road_bg)
	Background:addChild(Road)

	stage:addChild(Sky)
	stage:addChild(Star.layer)
	stage:addChild(Background)
	stage:addChild(Sun)
	stage:addChild(Cloud.layer)
	stage:addChild(Objects.rear_layer)
	stage:addChild(Car.layer)
	stage:addChild(Cloud.rain_layer)
	stage:addChild(Objects.front_layer)
	stage:addChild(GUI)
	
	
 	Upgrade.init()
	
	
	DEBUG_DICE = debug_dice
end

function Game.reset_saved_data()
	local file = io.open("|D|save.txt", "w")
	file:close()
end

function Game.update()
	
end