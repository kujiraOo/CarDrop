Car = {}
Car.layer = Sprite.new()

Car.CAR_SFX_VOLUME = 0.3

function Car.init()
	Car.layer.x = 180
	Car.layer.y = 190
	Car.speed_default = 8
	Car.accel = 0.3
	Car.friction = 1.02
	Car.speed = 0
	Car.accelerating = false
	
	--Car:setPosition(Car.x, Car.y)
	Car.layer:setPosition(Car.layer.x, Car.layer.y)

	Car.img = Bitmap.new(Main_pack:getTextureRegion("car.png"))
	Car.wheels_x = 30
	Car.wheels_y = 50
	Car.wheels_offset = 70
	

	local wheels = Car.wheels_init(Main_pack:getTextureRegion("wheel.png"), Car.wheels_offset)
	wheels:setPosition(Car.wheels_x, Car.wheels_y)
	
	Car.lights = Bitmap.new(Main_pack:getTextureRegion("lights.png"))
	Car.lights.light = true
	
	Car.sound_channel = Sound.new("sound/car.wav"):play(0, true, true)
	Car.sound_channel:setVolume(Car.CAR_SFX_VOLUME)
	--Car.sound_channel:setPitch(0.8)
	
	Car.layer:addChild(Car.img)
	
	Car.layer:addChild(wheels)
	
	Car.layer:addChild(Car.lights)
	
	stage:addEventListener(Event.ENTER_FRAME, function()
		if Car.accelerating then
			Car.speed = Car.speed + Car.accel
			
			if Car.speed > Car.speed_default then
				Car.speed = Car.speed_default
			end
		else
			Car.speed = Car.speed / Car.friction
			
			if Car.speed < 1 then
				Car.speed = 0
			end
		end
		end)
end



function Car.wheels_init(txr, offset)

	local sprite = Sprite.new()
	
	sprite.id = "wheels"
	
	sprite.angle = 0

	local wheel1 = Bitmap.new(txr)
	wheel1:setAnchorPoint(0.5, 0.5)
	
	local wheel2  = Bitmap.new(txr)
	wheel2:setAnchorPoint(0.5, 0.5)
	wheel2:setX(offset)
	
	sprite:addChild(wheel1)
	sprite:addChild(wheel2)
	
	sprite:addEventListener(Event.ENTER_FRAME, Car.wheels_rotate, sprite)
	
	return	sprite
end


function Car.wheels_rotate(sprite)
	if Car.speed > 0 then
		sprite.angle = sprite.angle + Car.speed * 3
		sprite:getChildAt(1):setRotation(sprite.angle)
		sprite:getChildAt(2):setRotation(sprite.angle)
	end
end
