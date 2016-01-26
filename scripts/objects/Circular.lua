Circular = Core.class(Object)

function Circular.spawn (dice)
	local object = Circular.new()
	local name = Objects_data[dice].name
	local img = Bitmap.new(Objects.local_pack:getTextureRegion(name..".png"))
	img:setAnchorPoint(0.5, 0.5)
	
	object.type = Objects_data[dice].type
	object.y = -100
	
	object.description = Objects_data[dice].name:match(".+_(.+)")
	
	object:addChild(img)
	
	object.circular_radius = 30
	object.circular_angle = 0
	object.circular_x = 0
	object.circular_y = 0
	

	
	local function touch(event)
		if object:hitTestPoint(event.touch.x, event.touch.y) then
			Sfx.play("ufo")
		
			object:removeEventListener(Event.TOUCHES_BEGIN, touch)
			object:removeEventListener(Event.ENTER_FRAME, Object.on_enter_frame, object)
			
			object:escape_movement_init()
			object:addEventListener(Event.ENTER_FRAME, Circular.escape_movement, object)
		end
	end
	
	object:addEventListener(Event.TOUCHES_BEGIN, touch)
	
	
	return object
end


function Circular:move()
	
	self.circular_angle = self.circular_angle + 0.1
	
	self.circular_x = math.cos(self.circular_angle) * self.circular_radius
	self.circular_y = math.sin(self.circular_angle) * self.circular_radius

	if not self.falling then
		
		if self.layer == "front1" 
		or self.layer == "front2" 
		or self.layer == "front_light" then
			self.x = self.x - 1.5 * Car.speed
		else
			self.x = self.x - 0.5 * Car.speed
		end
	end
	
	self:setPosition(self.x + self.circular_x, self.y + self.circular_y)
	
	if self.x < -100 - self.width/2 then
		self:remove_from_stage()
	end
end


function Circular:remove_from_stage(escape)
	if escape then
		self:removeEventListener(Event.ENTER_FRAME, Circular.escape_movement, self)
		self:getParent():removeChild(self)
		self = nil
	else
		self:removeEventListener(Event.ENTER_FRAME, Object.on_enter_frame, self)
		self:getParent():removeChild(self)
		self = nil
	end
end

function Circular:escape_movement_init()
	self.escape_mode = math.random(1, 3)
	
	
	-- чтобы объединить x и y вращения и линейного движения
	self.x, self.y = self:getPosition()
	
	-- зиг-заг
	if self.escape_mode == 1 then
		self.speed_x = -4
		self.speed_y = -8
		self.phase = 1
		
		if self.layer == "rear_ord" or self.layer == "rear_light" then
			self.bottom = 200 - self:getWidth()/2 - 20
		else
			self.bottom = 295 - self:getWidth()/2 - 20
		end
		
	-- трясется и улетает
	elseif self.escape_mode == 2 then
		Objects.circular_escape_layer:addChild(self)
	
		self.shake_timer = 0
		self.speed_x = 1
		if self.layer == "rear_light" then
			self.speed_y = -10
		else
			self.speed_y = 10
		end
		
	-- варп
	else
		self.scale = self:getScaleX()
		self.scale_lim = math.random(10, 15)/10
		self.axis = 1
		self.scale_count = 1
		self.scale_speed = 0.1
		self.phase = 1
	end
end


function Circular:escape_movement()

	if self.escape_mode == 1 then
		self:zig_zag()
		
	elseif self.escape_mode == 2 then
		self:shake()
		
	else
		self:warp()
	end
end

function Circular:zig_zag()
	self.x = self.x + self.speed_x
	self.y = self.y + self.speed_y
	self:setPosition(self.x, self.y)
		
	if self.phase == 1 then
		if self.y < 0  then
			self.y = 0 
			self.speed_y = - self.speed_y
		elseif self.y > self.bottom  then
			self.y = self.bottom 
			self.speed_y = -self.speed_y
		end
		
		if self.x < 0 then
			self.x = 0
			self.speed_x = -self.speed_x * 2
			self.speed_y = 0
			
			self:setScaleX(-1)
			
			self.phase = 2
			
		end
			
	elseif self.phase == 2 then
		if self.speed_x > 0 and self.x > 350 then
			self.speed_x = 0
			self.x = 350
			self.speed_y = -10
		end
		
		if self.y < -50 then
			self:remove_from_stage(true)
		end
	end
end

function Circular:shake()
	if self.shake_timer < 90 then
		self.x = self.x + self.speed_x
		if self.speed_x > 0 then
			self.speed_x = -self.speed_x - 0.1
		else
			self.speed_x = -self.speed_x + 0.1
		end
		self:setX(self.x)
		self.shake_timer = self.shake_timer + 2
	else 
		self.y = self.y + self.speed_y
		self:setY(self.y)
		if self.y < -100 or self.y > 400 then
			self:remove_from_stage(true)
		end
	end
end



function Circular:warp()
	-- Режим побега тарелки 3
	-- Тарелка сплющивается и растягивается по вертикали
	-- и горизонтали до рандомных пределов, потом сплющивается 
	-- до 0
	 
	-- Каждый раз, когда scale доходит до лимита, скорость меняется
	-- на противоположную 
	
	-- Каждый из двух раз меняется ось, на 2 и 4 разы приходится
	-- доставать scale с помощью getScaleX или getScaleY, чтобы прибавлять к 
	-- скейлу соотвествующей оси
	
	-- 2 раза по 4 кадра
	
	-- 1 x+
	-- 2 x-
	-- 3 y+
	-- 4 y-
	-- ----
	-- 9 x+
	-- 10 y+
	-- 11 y- конец
	
	
	self.scale = self.scale + self.scale_speed
	
	if self.axis == 1 then
		self:setScaleX(self.scale)
	else
		self:setScaleY(self.scale)
	end
		
	if (self.scale_speed > 0 and self.scale > self.scale_lim)
	or (self.scale_speed < 0 and self.scale < self.scale_lim) then
	
		--print (self.axis, self.scale_count, self.scale_speed)
		
		if self.scale_count <= 8 then
		
			self.scale_speed = -self.scale_speed
			
			-- если счет нечетный
			if self.scale_count % 2 == 1 then 
				self.scale_lim = math.random(5, 10)/10
				
			-- если четный
			else
				self.scale_lim = math.random(10, 15)/10
				self.axis = -self.axis
				
				if self.scale_count % 4 == 0 then
					self.scale = self:getScaleX()
				else
					self.scale = self:getScaleY()
				end
			end
			
		
		elseif self.scale_count == 9 then
			self.scale_lim = math.random(10, 15)/10
			self.axis = -self.axis
			self.scale = self:getScaleY()

		
		elseif self.scale_count == 10 then
			self.scale_lim = 0
			self.scale_speed = -self.scale_speed
		
		elseif self.scale_count == 11 then
			self:remove_from_stage(true)
		end
		
		self.scale_count = self.scale_count + 1
	end
end