Distancer_rnd = Core.class()

function Distancer_rnd:init(foo, lim1, lim2, running)
	--print ("LIM1 LIM2", lim1, lim2)
	
	self.lim1 = lim1
	self.lim2 = lim2
	
	self.i = 0
	
	self.lim = math.random(self.lim1, self.lim2)
	
	self.running = running
		
	
	stage:addEventListener(Event.ENTER_FRAME, function()
		if self.running then
			self.i = self.i + Car.speed
			if self.i >= self.lim then
				foo()
				self.i = 0
				self.lim = math.random(self.lim1, self.lim2)
			end
		end
		end)
end

function Distancer_rnd:set_lim(lim1, lim2)
	self.lim1, self.lim2 = lim1, lim2
	--print(self.lim1, self.lim2)
end

function Distancer_rnd:start()
	self.running = true
end

function Distancer_rnd:pause()
	self.running = false
end