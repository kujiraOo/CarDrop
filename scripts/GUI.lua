GUI = Sprite.new()
GUI.move_button = Sprite.new()


GUI.sound_button = Sprite.new()
GUI.sound_button.x = 15 - DX
GUI.sound_button.y = 5 - DY



-- для экранов 240х320 задать размер шрифта 10
if DEVICE_WIDTH < 320 then
	 GUI.font = Font.new("gfx/font/asap10.txt", "gfx/font/asap10.png")
else
	 GUI.font = Font.new("gfx/font/asap.txt", "gfx/font/asap.png", true)
end



function GUI.init()

	GUI.move_button.init()
	GUI:addChild(GUI.move_button)
	
	GUI.player_record_init()
	GUI:addChild(GUI.distance_textfield)
	GUI:addChild(GUI.day_textfield)
	GUI:addChild(GUI.object_description)
	
	GUI.sound_button.init()
	GUI:addChild(GUI.sound_button)
end


function GUI.move_button.init()
	GUI.move_button.default_img = Bitmap.new(Main_pack:getTextureRegion("button_default.png"))
	GUI.move_button:addChild(GUI.move_button.default_img)
	
	
	GUI.move_button.pressed_img = Bitmap.new(Main_pack:getTextureRegion("button_pressed.png"))
	GUI.move_button.pressed_img:setVisible(false)
	GUI.move_button:addChild(GUI.move_button.pressed_img)
	
	GUI.move_button.x = 30 - DX
	GUI.move_button.y = 230 + DY
	
	GUI.move_button:setPosition(GUI.move_button.x, GUI.move_button.y)
	
	GUI.move_button:addEventListener(Event.TOUCHES_BEGIN, GUI.move_button.pressed)
	GUI.move_button:addEventListener(Event.TOUCHES_END, GUI.move_button.released)
end


function GUI.move_button.pressed(event)
	if GUI.move_button:hitTestPoint(event.touch.x, event.touch.y) then
		GUI.move_button.default_img:setVisible(false)
		GUI.move_button.pressed_img:setVisible(true)
		
		GUI.move_button.touch_id = event.touch.id
		
		Car.sound_channel:setPaused(false)
		
		Car.accelerating = true
		

	end
end


function GUI.move_button.released(event)
	if event.touch.id == GUI.move_button.touch_id then
		GUI.move_button.touch_id  = nil
		
		GUI.move_button.default_img:setVisible(true)
		GUI.move_button.pressed_img:setVisible(false)
		
		Car.sound_channel:setPaused(true)
		Car.accelerating = false


	end
end

function GUI.player_record_init()

	
	GUI.distance_textfield = TextField.new(GUI.font, "Journey: "..Game.distance.." m")
	GUI.day_textfield = TextField.new(GUI.font, "Day: "..Game.day)
	GUI.object_description = TextField.new(GUI.font, nil)
	
	if DEVICE_WIDTH < 320 then
		local scale = 1 / application:getLogicalScaleX()
		GUI.distance_textfield:setScale(scale)
		GUI.day_textfield:setScale(scale)
		GUI.object_description:setScale(scale)
	end
	
	GUI.distance_textfield:setTextColor(0xffffff)
	GUI.day_textfield:setTextColor(0xffffff)
	GUI.object_description:setTextColor(0xffffff)
	
	GUI.object_description:setPosition(GUI.sound_button.x + 25, GUI.sound_button.y + 15)
	
	GUI.distance_textfield.y = 20 - DY
	GUI.distance_textfield:setPosition(APP_WIDTH - GUI.distance_textfield:getWidth() - 20 + DX, GUI.distance_textfield.y)
	GUI.day_textfield:setPosition(GUI.distance_textfield:getX() - GUI.day_textfield:getWidth() - 10, GUI.distance_textfield.y)
	
end



function GUI.sound_button.init()
	local bmp = Bitmap.new(Main_pack:getTextureRegion("sound.png"))
	
	if SOUND_ON then
		bmp:setAlpha(1)
		Car.sound_channel:setVolume(Car.CAR_SFX_VOLUME)
	else
		bmp:setAlpha(.5)
		Car.sound_channel:setVolume(0)
	end
	
	GUI.sound_button:addChild(bmp)
	
	GUI.sound_button.size = 70
	
	GUI.sound_button:setPosition(GUI.sound_button.x, GUI.sound_button.y)
	
	GUI.sound_button:addEventListener(Event.TOUCHES_BEGIN, GUI.sound_button.pressed)
end

function GUI.sound_button.pressed(event)
	if General.hit(GUI.sound_button.size, GUI.sound_button.x, GUI.sound_button.y, event.touch.x, event.touch.y) then
		SOUND_ON = not SOUND_ON
		
		local bmp = GUI.sound_button:getChildAt(1)
		
		if SOUND_ON then
			Music.channel:setVolume(1)
			Car.sound_channel:setVolume(Car.CAR_SFX_VOLUME)
			
			bmp:setAlpha(1)
		else
			Music.channel:setVolume(0)
			Car.sound_channel:setVolume(0)
			
			bmp:setAlpha(.5)
		end
		
		
		print ("SOUND_ON", SOUND_ON)
	end
end