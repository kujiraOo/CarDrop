Star = Core.class(Sprite)
Star.layer = Sprite.new()

function Star.load()
	Star.texture = Main_pack:getTextureRegion("star.png")
	Star.layer:setAlpha(0)
	Star.alpha = 0 
	Star.layer:addEventListener(Event.ENTER_FRAME, Star.layer.on_enter_frame)
end

function Star.layer.on_enter_frame()
	if not Sun.is_sun then
		if Sun.x < 130 then
			Star.alpha = Star.alpha - Sun.speed / 125
			Star.layer:setAlpha(Star.alpha)
		else
			if Star.alpha < 1 then
				Star.alpha = Star.alpha + Sun.speed / 125
				Star.layer:setAlpha(Star.alpha)
			else
				Star.alpha = 1
				Star.layer:setAlpha(1)
			end
		end
	else
		Star.alpha = 0
	end
end



function Star.spawn()
	--print ('spawn stars')
	local num = math.random (5, 20)
	--print(num)
	for i = 0, num do
		local star = Star.new()
		local img = Bitmap.new(Star.texture)
		img:setAnchorPoint(0.5, 0.5)
		star:addChild(img)
		star:setScale(math.random(50,100)/100)
		
		star.x = 440/num * i
		star.y = math.random(0, 7) * 16
		star.angle = 0
		star.speed_y = math.random(1,10) * 2
		
		if General.square_hit(star.x, star.y, 50, GUI.sound_button.x, GUI.sound_button.y, GUI.sound_button.size) then
			star.x = star.x + 100
		end
		
		star:setPosition(star.x, star.y)
		
		Star.layer:addChild(star)
		
		star:addEventListener(Event.TOUCHES_BEGIN, Star.touch, star)
	end
end

function Star.remove()
	for i = Star.layer:getNumChildren(), 1, -1 do
		Star.layer:removeChildAt(i)
	end
end

function Star:on_enter_frame()
	self.angle = self.angle + 0.1
	self.x = self.x -  2 * math.cos(self.angle)
	self.y = self.y +  self.speed_y * math.sin(self.angle)
	self:setPosition(self.x, self.y)
end

function Star:touch(event)
	local size = 25
	if event.touch.x > self.x - size and event.touch.x < self.x + size
	and event.touch.y > self.y - size and event.touch.y < self.y + size then
		--print("star touched")
		self:addEventListener(Event.ENTER_FRAME, Star.on_enter_frame, self)
		self:removeEventListener(Event.TOUCHES_BEGIN, Star.touch, self)
		Star.touched_count = Star.touched_count + 1
		--print("Stars touched now: "..Star.touched_count)
		
		if Upgrade.level < Upgrade.max_level 
		and Star.touched_count >= Upgrade.req then
			Upgrade.level_up()
		end
	end
end