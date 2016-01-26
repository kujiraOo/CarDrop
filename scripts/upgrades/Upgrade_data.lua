local function bmp(file)
	return Bitmap.new(Upgrade.pack:getTextureRegion(file))
end

local function fire(txr_string, rs, gs, bs, rd, gd, bd)
	local fire = bmp(txr_string)
	fire:setAnchorPoint(1, 0.5)
	
	local scale = 1
	local scale_speed = -0.03
	
	
	-- в коде  - позиция [1], скорость цвета [2-4], глубина цвета[5-7]
	
	local r = 1 
	local g = 1
	local b = 1
	local r_speed = -0.004 * rs
	local g_speed = -0.004 * gs
	local b_speed = -0.004 * bs
	local r_depth = 0.1 * rd
	local g_depth = 0.1 * gd
	local b_depth = 0.1 * bd
	
	fire:addEventListener(Event.ENTER_FRAME, function()
		scale = scale + scale_speed
		
		fire:setScale(scale)
		if scale < 0.6 then
			scale_speed = -scale_speed
			scale = 0.6
		elseif scale > 1.2 then
			scale_speed = -scale_speed
			scale = 1.2
		end
		
		r = r + r_speed
		g = g + g_speed
		b = b + b_speed
		
		fire:setColorTransform(r, g, b)
		
		if r > 1 then
			r_speed = -r_speed
		elseif r < r_depth then
			r_speed = -r_speed
		end
		
		if g > 1 then
			g_speed = -g_speed
		elseif g < g_depth then
			g_speed = -g_speed
		end
		
		if b > 1 then
			b_speed = -b_speed
		elseif b < b_depth then
			b_speed = -b_speed
		end
		
		end)
	
	
	return fire
end

local function frames(frame1, frame2, len, prop)
	local mc
	
	local frame1 = bmp(frame1)
	
	local prop = prop or 0.5
	local len = len or 30
	
	local fr = len * prop -- пропорциональное количество кадров
	
	
	
	
	if frame2 == "alpha" then
		mc = MovieClip.new{
			{     1,  fr, frame1, {alpha = {1, 0.2}}},
			{fr + 1, len, frame1, {alpha = {0.2, 1}}},
		}
		
	elseif frame2 == "y" then
		mc = MovieClip.new{
			{     1,  fr, frame1, {y = -2}},
			{fr + 1, len, frame1, {y = -1}},
		}
		
	else
		local frame2 = bmp(frame2)
	
		mc = MovieClip.new{
			{     1,  fr, frame1},
			{fr + 1, len, frame2},
		}
	end
	
	mc:setGotoAction(len,1)
	
	return mc
end

local function rotation(txr_string, anchor_x, anchor_y, angle1, angle2)
	local bmp = Bitmap.new(Upgrade.pack:getTextureRegion(txr_string))
	bmp:setAnchorPoint(anchor_x, anchor_y)
	
	local mc = MovieClip.new{
		{ 1, 30, bmp, {rotation = {angle1, angle2}}},
		{31, 60, bmp, {rotation = {angle2, angle1}}},
	}
	
	mc:setGotoAction(60, 1)
	
	return mc
end

local function vehicle(txr_string, x, y, offset)
	local sprite = Sprite.new()
	
	local bmp = Bitmap.new(Upgrade.pack:getTextureRegion(txr_string..".png"))
	local wheels = Car.wheels_init(Upgrade.pack:getTextureRegion(txr_string.."_wheel.png"), offset)
	
	wheels:setPosition(x, y)
	
	sprite:addChild(bmp)
	sprite:addChild(wheels)
	
	return sprite
end

local function steam(txr_string)
	local bmps = {}
	for i = 1, 3 do
		local bmp = bmp(txr_string)
		bmp:setAnchorPoint(0.5, 0)
		
		table.insert(bmps, bmp)
	end
	
	
	local mc = MovieClip.new{
		{1, 60, bmps[1], {y = {0, -25}}},
		{1, 60, bmps[1], {scale = {0.25, 1}}},
		{1, 30, bmps[1], {alpha = {0.5, 1}}},
		{31, 60, bmps[1], {alpha = {1, 0}}},
		
		{21, 80, bmps[2], {y = {0, -25}}},
		{21, 80, bmps[2], {scale = {0.25, 1}}},
		{21, 50, bmps[2], {alpha = {0.5, 1}}},
		{51, 80, bmps[2], {alpha = {1, 0}}},
		
		{41, 100, bmps[3], {y = {0, -25}}},
		{41, 100, bmps[3], {scale = {0.25, 1}}},
		{41, 70,  bmps[3], {alpha = {0.5, 1}}},
		{71, 100, bmps[3], {alpha = {1, 0}}},
	}
	mc:setGotoAction(100, 1)
	
	return mc
end

local function doshirak()
	local sprite = vehicle("other/doshirak", 18, 97, 58)
	
	local head = rotation("other/doshirak_head.png", 0.5, 0.5, -20, 20)
	head:setPosition(65, 59)
	
	local cloud = steam("other/doshirak_cloud.png")
	cloud:setPosition(28, 60)
	
	sprite:addChild(head)
	sprite:addChild(cloud)
	
	return sprite
end

local function casino()
	local sprite = vehicle("other/casino", 36, 165, 46)
	local light = frames ("other/casino_light.png", "alpha")
	light:setY(60)
	
	sprite:addChild(light)
	
	return sprite
end

local function girl()
	local sprite = Sprite.new()
	local l = rotation("other/funnygirl_hand.png", 1, 1, -15, 15)
	local r = rotation("other/funnygirl_hand.png", 1, 1, -15, 15)
	
	l:setPosition(10, 20)
	
	r:setScaleX(-1)
	r:setPosition(25, 20)
	
	local bmp = bmp("other/funnygirl.png")
	
	sprite:addChild(bmp)
	sprite:addChild(l)
	sprite:addChild(r)

	return sprite
end



local function turbo_spoiler()
	local sprite = Sprite.new()
	
	local bmp = bmp("spoiler/turbo.png")
	
	local fire = fire("spoiler/turbo_fire.png", 0, 6, 4, 1, 7, 7)
	fire:setPosition(1, 4)
	
	sprite:addChild(fire)
	
	sprite:addChild(bmp)
	
	
	return sprite
end

function Upgrade.load_data() 

	Upgrade.data = {

		-- SPOILER
		{x =  2, y =  18, id = "spoiler",  spr = bmp("spoiler/spoiler.png")},
		
		
		-- POP
		
		{x = 0,  y =   0, id = "wheels", txr = "wheels/pop.png"},
		 
		--{x = 70, y = -15, id = "other",   spr = bmp("other/chiсken.png")},
		
		{x = 43, y =  29, id = "other",  spr = bmp("other/wings.png")},
		
		{x = 65, y =  -2, id = "other",  l = true,  spr = frames("other/flasher1.png", "other/flasher2.png")},
		
		-- SNAIL
		
		{x = 0, y = 0, id = "wheels", txr = "wheels/snail.png"},
		
		{x = 56, y = -2, id = "other", spr = bmp("other/usiki.png")},
		
		-- SNAKE
		
		{x = 17, y = 28, id = "spoiler", spr = rotation("spoiler/snake.png", 1, 1, -15, 15)},
		
		-- PURPLE
		
		{x = 0, y = 0, id = "wheels", txr = "wheels/purplestar.png"},
		
		{x = 58, y = 15, id = "other", spr = bmp("other/heartglasses.png")},
		
		{x = -106, y = -50, id = "other", spr = doshirak()},
		
		-- BANANA
		
		{x = 0, y = 0, id = "wheels", txr = "wheels/banana.png"},
		
		{x = -4, y = -27, id = "other", spr = bmp("other/lion.png")},
		
		{x = 39, y = -30, id = "other", spr = bmp("other/bagaj.png")},
		
		{x = 70, y = 15, id = "other", spr = bmp("other/stupidglasses.png")},
		
		{x = 18, y = -30, id = "other", spr = bmp("other/garden.png")},
		
		-- PIZZA
		
		{x = 0, y = 0, id = "wheels", txr = "wheels/pizza wheel.png"},
		
		{x = 40, y = -20, id = "other", spr = bmp("other/cowboy hat.png")},
		
		{x = 49, y = -18, id = "other", spr = girl()},
		
		-- TURBO
		
		{x =  2, y =  16, id = "spoiler", l = true, spr = turbo_spoiler()},
		
		-- SEASTAR
		
		{x = 0, y = 0, id = "wheels", txr = "wheels/seastar.png"},
		
		{x = -100, y = -113, id = "other", l = true, spr = casino()},
		
		{x = -15, y = -27, id = "other", spr = bmp("other/crab.png")},
		
		{x = 8, y = - 35, id = "other", spr = frames("other/octopus1.png", "other/octopus2.png", 90, 0.95)},
		
		
	}
	
	Upgrade.max_level = #Upgrade.data

end