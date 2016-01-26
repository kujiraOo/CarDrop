Upgrade_animation = {}

local stars = {radius = 20, upgrade_timer = 0}

function Upgrade_animation.init()
	for i = 1, 4 do
		stars[i] = Bitmap.new(Upgrade.pack:getTextureRegion("star"..i..".png"))
		stars[i]:setX(i * 20)
		
		stars[i].x = 100
		stars[i].y = 0
	end
end

function Upgrade_animation.play()
	for i = 1, 4 do
		stars[i].x = 120
		stars[i].y = 0
		stars[i].angle = 0
		
		stars[i].pass = 0
		
		stars[i].anim = false 
		
	end
	
	stars.anim_speed = 2
	
	stars.upgrade_timer = 0
	
	stars.anim_count = 1
	
	stars[1].anim = true
	Car.layer:addChild(stars[1])
	
	Car.layer:addEventListener(Event.ENTER_FRAME, stars.enter_frame)
end

function stars.spawn()
	if stars.anim_count < #stars then
		stars.anim_count = stars.anim_count + 1
		stars[stars.anim_count].anim = true
		Car.layer:addChild(stars[stars.anim_count])
	end
end

function stars.enter_frame ()

	stars.upgrade_timer = stars.upgrade_timer + stars.anim_speed

	if stars.upgrade_timer > 25 then
		stars.spawn()
		stars.upgrade_timer = 0
	end

	for i = 1, 4 do
		if stars[i].anim then
			stars[i].x = stars[i].x - stars.anim_speed
			stars[i].angle = stars[i].angle + stars.anim_speed / 10
			stars[i].y =  math.sin(stars[i].angle) * 10 + 10
			
			stars[i]:setAlpha(math.sin(stars[i].angle) + 1.4)
			
			stars[i]:setPosition(stars[i].x, stars[i].y)
			
			if stars[i].x < 0 then
				stars[i].pass = stars[i].pass + 1
				
				if stars[i].pass == 3 then
					Car.layer:removeChild(stars[i])
					
					if i == 4 then
						Car.layer:removeEventListener(Event.ENTER_FRAME, stars.enter_frame)
					end
				end
				
				stars[i].x = 100
			end
		end
	end
end