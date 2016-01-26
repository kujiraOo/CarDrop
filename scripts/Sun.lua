Sun = Sprite.new()

Filter = {
	red = 1,
	green = 1,
	blue = 1
}

function Sun.init()
	Sun.x, Sun.y = 350, 60
	Sun.speed = 1 -- не забыть вернуть 0.5
	Sun.rotation_speed = 2
	Sun.rotation = 0 
	Sun.filter = {green = 1, blue = 1}
	Sun.is_sun = true
	
	-- для анимации луны
	Sun.moon_anim_count = 1
	
	Sun.sun = Bitmap.new(Main_pack:getTextureRegion("sun.png"))
	Sun.sun:setAnchorPoint(0.5, 0.5)
	Sun:addChild(Sun.sun)
	
	--[[Sun.mc = MovieClip.new{
		{1, 180, Sun.sun, {rotation = {0, 360}}}
	}
	Sun.mc:setGotoAction(180, 1)]]
	
	Sun.moon = Bitmap.new(Main_pack:getTextureRegion("moon.png"))
	Sun.moon:setAnchorPoint(0.5, 0.5)
	Sun.moon:setVisible(false)
	Sun:addChild(Sun.moon)
	
	Sun:setPosition(Sun.x, Sun.y)
	
	Sun:addEventListener(Event.ENTER_FRAME, Sun.on_enter_frame)
	Sun:addEventListener(Event.TOUCHES_BEGIN, Sun.on_touch)
end

function Sun.on_touch(event)
	if Sun.is_sun and Sun.sun:hitTestPoint(event.touch.x, event.touch.y) then
		Sun.rotation_speed = - Sun.rotation_speed
		
	elseif not Sun.is_sun and Sun.moon:hitTestPoint(event.touch.x, event.touch.y) then
	
		if not Sun.moon_anim then
			Sun.moon_anim = true
			
			local angle1, angle2
			
			if Sun.moon_anim_count % 2 == 0 then
				angle1, angle2 = 0, 360
			else
				angle1, angle2 = 360, 0
			end
			
			
			Sun.moon_mc = MovieClip.new{
				{1, 60, Sun.moon, {rotation = {angle1, angle2, "outBack"}}}
			}
			Sun.moon_mc:addEventListener(Event.COMPLETE, function() Sun.moon_anim = false end)
			
			Sun.moon_anim_count = Sun.moon_anim_count + 1
		end
	end
end

local function transform_color()
	
	for i = 1, Car.layer:getNumChildren() do
		local sprite = Car.layer:getChildAt(i)
		if not sprite.light then
			sprite:setColorTransform(Filter.red, Filter.green, Filter.blue)
		end
	end
	
	Sky:setColorTransform(Filter.red, Filter.green, Filter.blue)
	Background:setColorTransform(Filter.red, Filter.green, Filter.blue)
	Objects.front_layer1:setColorTransform(Filter.red, Filter.green, Filter.blue)
	Objects.front_layer2:setColorTransform(Filter.red, Filter.green, Filter.blue)
	Objects.rear_layer_ord:setColorTransform(Filter.red, Filter.green, Filter.blue)
	Objects.rear_layer_trees:setColorTransform(Filter.red, Filter.green, Filter.blue)
	Cloud.layer:setColorTransform(Filter.red, Filter.green, Filter.blue)
	Cloud.rain_layer:setColorTransform(Filter.red, Filter.green, Filter.blue)
end

function Sun.on_enter_frame()
	Sun.x = Sun.x - Sun.speed
	Sun:setX(Sun.x)
	
	if Sun.is_sun then
		Sun.rotation = Sun.rotation + Sun.rotation_speed
		Sun.sun:setRotation(Sun.rotation)

	end
	
	Sun.on_left_edge()
	
	if Sun.x < 130 then
		if Sun.is_sun then
			Filter.red = Filter.red - 0.0005 * Sun.speed
			Filter.blue = Filter.blue - 0.002 * Sun.speed
			Filter.green = Filter.green - 0.002 * Sun.speed
			--print(Filter.red, Filter.green, Filter.blue)
			 
			transform_color()
			
			Sun.filter.green = Sun.filter.green - 0.002 * Sun.speed
			Sun.filter.blue = Sun.filter.blue - 0.002 * Sun.speed
			Sun:setColorTransform(1, Sun.filter.green, Sun.filter.blue)
		else
			if Filter.red < 1 then
				Filter.red = Filter.red + 0.0015 * Sun.speed
			end
			if Filter.green < 1 then
				Filter.green = Filter.green + 0.001 * Sun.speed
			end
			if Filter.blue < 1 then
				Filter.blue = Filter.blue + 0.001 * Sun.speed
			end
			
			--print(Filter.red, Filter.green, Filter.blue)
			transform_color()
		end
	elseif Sun.x > 350 then
		if Sun.is_sun then
			if Filter.red < 1 then
				Filter.red = Filter.red + 0.003 * Sun.speed
			else
				Filter.red = 1
			end
			if Filter.green < 1 then
				Filter.green = Filter.green + 0.002 * Sun.speed
			else
				Filter.green = 1
			end
			if Filter.blue < 1 then
				Filter.blue = Filter.blue + 0.001 * Sun.speed
			else
				Filter.blue = 1
			end
			--print(Filter.red, Filter.green, Filter.blue)
			transform_color()
		else
			Filter.red = Filter.red - 0.0025 * Sun.speed
			Filter.green = Filter.green - 0.0009 * Sun.speed
			--print(Filter.red, Filter.green, Filter.blue)
			
			transform_color()
		end
	end
	
end

function Sun.on_left_edge()
	if Sun.x < -110 then
		Sun.x = 600
		if Sun.is_sun then
			Sun.is_sun = false
			Sun.sun:setVisible(false)
			Sun.moon:setVisible(true)
			
			Sun.rotation = 0
			Sun.rotation_speed = 20
			Sun:setRotation(0)
			
			Sun.filter.green = 1
			Sun.filter.blue = 1
			Sun:setColorTransform(1, 1, 1, 1)
			
			
			Star.spawn()
		else
			Sun.is_sun = true
			Sun.sun:setVisible(true)
			Sun.moon:setVisible(false)
			
			Sun.rotation_speed = 2
			
			Game.day = Game.day + 1
			GUI.day_textfield:setText("Day: "..Game.day)
			GUI.day_textfield:setX(GUI.distance_textfield:getX() - GUI.day_textfield:getWidth() - 10)
			
			Game.save()
			
			Star.remove()
			
			print("It's a new day and the distance is: "..Game.distance)
			
		end
	end
end
