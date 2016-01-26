Object = Core.class(Sprite)

Object.speed_y = 12


function Object:touched(touchX, touchY)
	local smallObjectSize = 40

	if self:getWidth() < smallObjectSize and self:getHeight() < smallObjectSize then
		
	
		local objectCenterX = self:getX()
		local objectCenterY = self:getY() - self:getWidth()/2
	
		return General.hit(smallObjectSize, objectCenterX, objectCenterY, touchX, touchY)
	
	else
		return self:hitTestPoint(touchX, touchY)
	end
	
end

function Object:onTouchAction()
	GUI.object_description:setText(self.description)
end

function Object:on_enter_frame()

	self:fall()
	
	self:move()
	
end

function Object:remove_from_stage()
	self:removeEventListener(Event.ENTER_FRAME, Object.on_enter_frame, self)
	self:getParent():removeChild(self)
	self = nil
	
end

function Object:move()
	if not self.falling then
		
		if self.layer == "front1" 
		or self.layer == "front2" 
		or self.layer == "front_light" then
			self.x = self.x - 1.5 * Car.speed
		else
			self.x = self.x - 0.5 * Car.speed
		end
	
		self:setX(self.x)
		
		if self.x < -100 - self.width/2 then
			self:remove_from_stage()
		end

	end
end

function Object:fall()
	if self.falling then
		if self.type == "floating" or self.type == "circular" then
			self.scale = self.scale + 0.08
			self:setScale(self.scale)
			if ((self.layer == "rear_ord" or
				self.layer == "rear_light") and 
				self.scale > 0.75)
			or ((self.layer == "front1" or 
				self.layer == "front2" or 
				self.layer == "front_light") and 
				self.scale > 1) 
			then
				self.falling = false
			end
			
			
		else
			self.y = self.y + self.speed_y		
			self.scale = self.scale + self.scale_speed
			
			if ((self.layer == "rear_ord" 
			or self.layer == "rear_light")
			and self.y >= 200) then
				
				self.falling = false
				self.y = 200

			elseif ((self.layer == "front1" 
			or self.layer == "front2" 
			or self.layer == "front_light") 
			and self.y >= self.front_layer_y ) then
				
				self.falling = false
				self.y = self.front_layer_y
				
			end
			
			self:setY(self.y)
			self:setScale(self.scale, self.scale)	
		end
	end
end

