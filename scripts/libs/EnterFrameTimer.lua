--[[
	File: EnterFrameTimer.lua
	-------------------------
	Таймер, который работает по энтер фрейму
	
	Когда отсчет доходит до задержки, таймер вызывает функцию
	и сбрасывается и останавливает отсчет, задержка остается прежней
	и таймер можно перезапустить.
	
	Задержка указывается в секундах
--]]

EnterFrameTimer = Core.class()

function EnterFrameTimer:init(foo, delay)

	self.i = 0
	self.delay = delay
	self.running = true

	
	stage:addEventListener(Event.ENTER_FRAME, function()
		if self.running then
			self.i = self.i + 1/30
			if self.i >= self.delay then
				foo()
				self.i = 0
				self.running = false
			end
		end
		end)

end

function EnterFrameTimer:pause()
	self.running = false
end

function EnterFrameTimer:resume()
	self.running = true
end

function EnterFrameTimer:setdelay(delay)
	self.delay = delay
end

--[[
	Метод перезапускает таймер, который вызывает
	ту же функцию и вызывает с такой же задержкой.
	
	Опционально можно задать новую задержку,
	задав параметр delay.
--]]
function EnterFrameTimer:restart(delay)
	self.i = 0
	self.delay = self.delay or delay
	self.running = true
end