Timer_rnd = Core.class()

function Timer_rnd:init(foo, lim1, lim2, running)
	--print ("LIM1 LIM2", lim1, lim2)
	
	self.lim1 = lim1
	self.lim2 = lim2
	
	self.i = 0
	
	self.lim = math.random(self.lim1, self.lim2)
	
	self.running = running
		
	
	stage:addEventListener(Event.ENTER_FRAME, function()
		if self.running then
			self.i = self.i + 1/30
			if self.i >= self.lim then
				foo()
				self.i = 0
				self.lim = math.random(self.lim1, self.lim2)
			end
		end
		end)
end

function Timer_rnd:set_lim(lim1, lim2)
	self.lim1, self.lim2 = lim1, lim2
	--print(self.lim1, self.lim2)
end

function Timer_rnd:start()
	self.running = true
end

function Timer_rnd:pause()
	self.running = false
end