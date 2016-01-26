Logo = {}
local logo_img = Bitmap.new(Startup_pack:getTextureRegion("logo.png"))
local alpha = 0 
local alpha_speed = 0.02



logo_img:setAlpha(0)
logo_img:setPosition(240 - logo_img:getWidth()/2, 160 - logo_img:getHeight()/2)

local function logo_on_enter_frame()
	alpha = alpha + alpha_speed
	logo_img:setAlpha(alpha)
	
	if alpha > 1.2 then
		alpha_speed = -0.02
	elseif alpha < 0 then
		stage:removeChild(logo_img)
		stage:removeEventListener(Event.ENTER_FRAME, logo_on_enter_frame)
		
		Game.load_data()
		Start_screen.init()
	end
end

function Logo.play ()
	stage:addChild(logo_img)
	stage:addEventListener(Event.ENTER_FRAME, logo_on_enter_frame)
end
