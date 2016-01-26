Start_screen = {}


-- локальные функции, чтобы не было проблем с порядком объявления
local waitInterstitialClosing, waitInterstitialLoading, screen_on_touch, screen_on_enter_frame
	
local timerWaitTime = 10

local screen_img = Bitmap.new(Startup_pack:getTextureRegion("start_screen.png"))
local alpha = 0


-- Функции для рекламы на андроиде




function screen_on_touch()

	-- если платформа андроид, то попытаться загрузить
	-- рекламу
	--
	-- подождать 5 секунд прежде, чем начать игру,
	-- чтобы за это время попытаться загрузить рекламу
	--
	-- если реклама уже загружена, то подождать, пока
	-- ее закроют
	-- 
	-- добавить загрузучную черепашку
	--
	
	LOADING_ANIMATION = Animations.rotate("gfx/loading.png", 1, 60)
	LOADING_ANIMATION:setPosition(APP_WIDTH/2, APP_HEIGHT/2)
	stage:addChild(LOADING_ANIMATION)
	
	if application:getDeviceInfo() == "Android" then
		waitInterstitialLoading()
	else
		Game.start()
	end
	

	stage:removeEventListener(Event.TOUCHES_BEGIN, screen_on_touch)
	stage:removeChild(screen_img)
	
	Startup_pack = nil
	
	collectgarbage()
	collectgarbage()
	collectgarbage()
	collectgarbage()
end


function waitInterstitialLoading() 
	local interstitialLoadingTimer = Timer.new(1000, timerWaitTime)
	
	interstitialLoadingTimer:addEventListener(Event.TIMER, function()
	
		if interstitialLoadingTimer:getCurrentCount() < timerWaitTime then
	
			if admob.isInterstitialLoaded() then
			
				admob.setVisible(true)
				
				waitInterstitialClosing()
	
				interstitialLoadingTimer:stop()
				
			end
			
		else
			Game.start()
		end
	end)

	interstitialLoadingTimer:start()
end

function waitInterstitialClosing()
	local interstitialClosingTimer = Timer.new(1000)
	
	interstitialClosingTimer:addEventListener(Event.TIMER, function()
	
		if admob.isInterstitialClosed() then
		
			Game.start()
			
			interstitialClosingTimer:stop()
			
		end
		
	end)
	
	interstitialClosingTimer:start()
end

function screen_on_enter_frame()
	alpha = alpha + 0.02
	screen_img:setAlpha(alpha)
	
	if alpha > 1 then
		
		stage:removeEventListener(Event.ENTER_FRAME, screen_on_enter_frame)
		
		stage:addEventListener(Event.TOUCHES_BEGIN, screen_on_touch)
		
	end
end

function Start_screen.init()

	screen_img:setAlpha(alpha)
	screen_img:setPosition(-63, -20)
	
	
	local tap = Bitmap.new(Startup_pack:getTextureRegion("tap_to_start.png"))
	screen_img:addChild(tap)
	tap:setPosition(120, 265)
	
	stage:addChild(screen_img)
	stage:addEventListener(Event.ENTER_FRAME, screen_on_enter_frame)
	
	
	-- DEBUG SECTION
	
	--[[local reset = TextField.new(nil, "reset")
	reset:setScale(3)
	reset:setPosition(100, 120)
	reset:setTextColor(0xffffff)
	screen_img:addChild(reset)
	
	reset:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if reset:hitTestPoint(event.touch.x, event.touch.y) then
			Game.reset_saved_data()
			reset:setText("saved data is reset")
			event:stopPropagation()
		end
		end)
	]]
	
		
	--[[
	local rates = {50, 250, 500}
	local rates_i = 1 
	
	local rate = TextField.new(nil, "objects change rate: __")
	rate:setScale(3)
	rate:setPosition(100, 160)
	rate:setTextColor(0xffffff)
	screen_img:addChild(rate)
	rate:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if rate:hitTestPoint(event.touch.x, event.touch.y) then
			Objects.set_change_rate(rates[rates_i])
		
			rate:setText("objects change rate: "..rates[rates_i])
			
			rates_i = rates_i + 1
			
			if rates_i > #rates then
				rates_i = 1
			end
			
			event:stopPropagation()
		end
		end)
		
		
		
	local urates = {1, 5, 25, 50}
	local urates_i = 1 
	
	local urate = TextField.new(nil, "upgrade change rate: "..Upgrade.change_rate)
	urate:setScale(3)
	urate:setPosition(100, 200)
	urate:setTextColor(0xffffff)
	screen_img:addChild(urate)
	urate:addEventListener(Event.TOUCHES_BEGIN, function(event)
		if urate:hitTestPoint(event.touch.x, event.touch.y) then
			Upgrade.change_rate = urates[urates_i]
		
			urate:setText("upgrade change rate: "..urates[urates_i])
			
			urates_i = urates_i + 1
			
			if urates_i > #urates then
				urates_i = 1
			end
			
			event:stopPropagation()
		end
		end)]]

end