function Object.ordinary(dice)
	local object = Object.new()
	local name = Objects_data[dice].name
	local img
	object.y = 0
	
	if Objects_data[dice].name:find("_") then 
		object.description = Objects_data[dice].name:match(".*_(.+)")
	else
		object.description = Objects_data[dice].name
	end
	

	img = Bitmap.new(Objects.local_pack:getTextureRegion(name..".png"))

	img:setAnchorPoint(0.5, 1)
	object:addChild(img)
	
	return object
end

function Object.floating(dice)
	local object = Object.new()
	local name = Objects_data[dice].name
	local img = Bitmap.new(Objects.local_pack:getTextureRegion(name..".png"))
	img:setAnchorPoint(0.5, 1)
	object.mc = MovieClip.new{
		{1, 50, img, {y = {0, 40, "linear"}}},
		{51, 100, img, {y = {40, 0, "linear"}}},
	}
	object.mc:setGotoAction(100, 1)
	
	object.type = Objects_data[dice].type
	
	object.y = -100
	
	object.description = Objects_data[dice].name:match(".*_(.+)")
	
	object:addChild(img)
	
	return object
end


function Object.wheel(dice)
	local object = Object.new()
	local wheel_txr, base_txr
	
	object.y = 0
	
	local name = Objects_data[dice].name
	
	
	
	base_txr = Objects.local_pack:getTextureRegion(name.."_b.png")
	wheel_txr = Objects.local_pack:getTextureRegion(name.."_a|"..Objects_data[dice].wheel_y..".png")
	
	
	local base = Bitmap.new(base_txr)
	local wheel = Bitmap.new(wheel_txr)
	
	base:setAnchorPoint(0.5, 1)
	wheel:setAnchorPoint(0.5, 0.5)
	wheel:setY(-Objects_data[dice].wheel_y)
	
	object.mc = MovieClip.new{
		{1, 150, wheel, {rotation = {0, 359}}}
	}
	object.mc:setGotoAction(150, 1)
	
	object:addChild(base)
	object:addChild(wheel)
	
	

	object.description = name:match(".*_(.*)")
	
	
	return object
end

function Object.fire(dice)


	local object = Object.new()
	
	object.y = 0
	
	local base = Bitmap.new(Objects.local_pack:getTextureRegion(Objects_data[dice].name.."_b.png"))
	base:setAnchorPoint(0.5, 1)
	
	local fire = Bitmap.new(Objects.local_pack:getTextureRegion(Objects_data[dice].name.."_a|"..Objects_data[dice].code..".png"))
	fire:setAnchorPoint(0.5, 1)
	
	local scale = 1
	local scale_speed = -0.006
	
	
	-- в коде  - позиция [1], скорость цвета [2-4], глубина цвета[5-7]
	
	local r = 1 
	local g = 1
	local b = 1
	local r_speed = -0.004 * Objects_data[dice].fire_data[2]
	local g_speed = -0.004 * Objects_data[dice].fire_data[3]
	local b_speed = -0.004 * Objects_data[dice].fire_data[4]
	local r_depth = 0.1 * Objects_data[dice].fire_data[5]
	local g_depth = 0.1 * Objects_data[dice].fire_data[6]
	local b_depth = 0.1 * Objects_data[dice].fire_data[7]
	
	fire:addEventListener(Event.ENTER_FRAME, function()
		scale = scale + scale_speed
		
		fire:setScale(scale)
		if scale < 0.8 then
			scale_speed = -scale_speed
			scale = 0.8
		elseif scale > 1 then
			scale_speed = -scale_speed
			scale = 1
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
	
	
	if Objects_data[dice].fire_data[1] == 0 then
		object:addChild(fire)	
		object:addChild(base)
	elseif Objects_data[dice].fire_data[1] == 1 then
		object:addChild(base)
		object:addChild(fire)
	end

	
	object.description = Objects_data[dice].name:match(".*_(.*)")
	
	
	return object
end