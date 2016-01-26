Cloud = Core.class(Sprite)

Cloud.layer = Sprite.new()

Cloud.rain_layer = Sprite.new()


function Cloud.load()

	Cloud.texture = Main_pack:getTextureRegion("cloud.png")

	--Cloud.timer:addEventListener(Event.TIMER, Cloud.spawn)
	--Cloud.timer:start()
	
	Cloud.timer = Timer_rnd.new(Cloud.spawn, 5, 5)

	Cloud.timer:start()

	local rain_txr = Main_pack:getTextureRegion("rain.png")

	local rain_sprite = Sprite.new()
	rain_sprite.x = 30
	rain_sprite:setRotation(15)
	rain_sprite.y = 0
	rain_sprite.angle = 105 * math.pi / 180
	rain_sprite:setX(rain_sprite.x)


	for x = 0, 5 do
		for y = -1, 4 do
			local rain_part = Bitmap.new(rain_txr)
			rain_part:setPosition(x * 16, y * 32 - x * 4)
			rain_sprite:addChild(rain_part)
		end
	end

	Cloud.rain_sprite = rain_sprite
	
	--print("Cloud rain sprite is: "..tostring(Cloud.rain_sprite))

	Cloud.rain_rt = RenderTarget.new(150, 130)

	stage:addEventListener(Event.ENTER_FRAME, Cloud.rain_on_enter_frame)
end




	
function Cloud.rain_on_enter_frame()
	local rain_sprite = Cloud.rain_sprite

	rain_sprite.y = rain_sprite.y + 2*math.sin(rain_sprite.angle)
	rain_sprite.x = rain_sprite.x + 2*math.cos(rain_sprite.angle)

	rain_sprite:setPosition(rain_sprite.x, rain_sprite.y)
		
	if rain_sprite.y > 32 * math.sin(rain_sprite.angle) then
		rain_sprite.y = rain_sprite.y - 32 * math.sin(rain_sprite.angle)
		rain_sprite.x = rain_sprite.x - 32 * math.cos(rain_sprite.angle)
	end
		
	Cloud.rain_rt:clear(0x000000, 0)
	Cloud.rain_rt:draw(rain_sprite)
end
	
	

function Cloud.spawn()
	
	local cloud = Cloud.new()
	local img = Bitmap.new(Cloud.texture)
	img:setAnchorPoint(0.5,1)
	cloud:addChild(img)
	
	cloud.speed = math.random(10, 20)/15
	cloud.x = 700

	cloud.y = math.random(64, 144)
	cloud:setPosition(cloud.x, cloud.y)
	
	cloud:addEventListener(Event.ENTER_FRAME, Cloud.move, cloud)
	cloud:addEventListener(Event.TOUCHES_BEGIN, Cloud.touch, cloud)
	
	Cloud.layer:addChild(cloud)
end


function Cloud:move()
	self.x = self.x - self.speed
	self:setX(self.x)
	
	
	if self.x < -150 then
		self:removeEventListener(Event.ENTER_FRAME, Cloud.move, self)
		
		if self.rain then
			Cloud.rain_layer:removeChild(self)
		else
			Cloud.layer:removeChild(self)
		end
		
		self = nil
	end
end

function Cloud:rain_start()
	print(Music.track_id)
	Sfx.play("rain")
	
	self.rain = Bitmap.new(Cloud.rain_rt)
	
	self.rain:setPosition( -80, -5)
	
	self:addChild(self.rain)
	Cloud.rain_layer:addChild(self)
	--Cloud.rain_layer:addChild(self.rain)
	print(Cloud.rain_layer:getNumChildren(), Cloud.layer:getNumChildren())
end



function Cloud:touch(event)
	if self:hitTestPoint(event.touch.x, event.touch.y) then
		self:removeEventListener(Event.TOUCHES_BEGIN, Cloud.touch, self)
		
		if math.random() > RAIN_CHANCE then
			self:removeEventListener(Event.ENTER_FRAME, Cloud.move, self)
			Cloud.layer:removeChild(self)
			
			Objects.spawn(true, self.x, self.y)
			
			self = nil
		else
			self:rain_start()
		end
	end
end