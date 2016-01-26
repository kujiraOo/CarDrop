Road = Sprite.new()

function Road.init()
	Road.x = 0
	Road.y = Car.layer.y + 20
	
	Road:setPosition(Road.x, Road.y)
	
	Road.texture = Main_pack:getTextureRegion("road.png")
	
	
	
	for i = -1, 9 do
		local road = Bitmap.new(Road.texture)
		road:setX(i * 64)
		Road:addChild(road)
	end
	
	Road:addEventListener(Event.ENTER_FRAME, Road.move)
end

function Road.move()
	Road.x = Road.x - Car.speed
	Road:setX(Road.x)
	
	--local fps = 1/event.deltaTime  
    --print(fps)
	
	if Road.x < -64 then
		Road.x = Road.x + 64
		
		Game.distance = Game.distance + 1
		GUI.distance_textfield:setText("Journey: "..Game.distance.." m")
		GUI.distance_textfield:setX(APP_WIDTH - GUI.distance_textfield:getWidth() - 20 + DX)
		GUI.day_textfield:setX(GUI.distance_textfield:getX() - GUI.day_textfield:getWidth() - 10)
		

		if Game.distance > Trees.distance then
			Trees.select()
		end
		
		if Game.distance > Objects.density_distance then
			Objects.select_density()
		end
		
		
		if Game.distance >= Objects.next_distance then
			Objects.change_local_objects()
			Objects.select_density()
		end
		
	end
end