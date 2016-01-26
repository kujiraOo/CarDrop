-- All animations return movieclips

Animations = {}

local initParabolicJump, updateParabolicJumpMotion, updateParabolicMotion, isXPointPassed
-- вращает один битмап вокруг своей оси до бесконечности
--
-- dir - направление вращения. 1 - по часовой, -1 - против
function Animations.rotate(path, dir, frames)
	
	local bmp = Bitmap.new(Texture.new(path))
	bmp:setAnchorPoint(0.5, 0.5)

	local mc = MovieClip.new{
		
		{1, frames, bmp, {rotation = {0, 360 * dir}}}
		
	}
	
	mc:setGotoAction(frames, 1)
	
	return mc
	
end



--[[
	Waving animation.
	Rotates bitmap around specified anchor point
	from angle1 to angle2 and then back from angle2 to angle1
]]
function Animations.waveMotion(bmp, anchor_x, anchor_y, angle1, angle2)
	bmp:setAnchorPoint(anchor_x, anchor_y)
	
	local mc = MovieClip.new{
		{ 1, 30, bmp, {rotation = {angle1, angle2}}},
		{31, 60, bmp, {rotation = {angle2, angle1}}},
	}
	
	mc:setGotoAction(60, 1)
	
	return mc
end



--[[
	Parabolic animation, get 2 points as arguments
	and height. Calculates animation of a sprite
	with 2 parabolas.
	
	jumpArgs table contains 
	sprite - sprite to animate,
	x, y - destination of jump,
	amp - jump height,
	vel - jump's speed
	
--]]
function Animations.parabolicJump(jumpArgs)

	-- Calculate more data about jump
	jumpArgs = initParabolicJump(jumpArgs)
	
	
	-- Update up and down motion
	jumpArgs.sprite:addEventListener(Event.ENTER_FRAME, updateParabolicJump, jumpArgs)
	
	--[[print("JUMP VERTEX X", jumpVertX)
	print("JUMP VERTEX Y", jumpVertY)]]
end



function initParabolicJump(jumpArgs)
	
	-- Calculate direction of jump
	if jumpArgs.x < jumpArgs.sprite:getX() then
		jumpArgs.vel = jumpArgs.vel * -1
	end
	
	--  X of vertex of jump motion is middle point 
	-- between sprite and destination point's X
	jumpArgs.vertX = jumpArgs.sprite:getX() + (jumpArgs.x - jumpArgs.sprite:getX()) / 2
	jumpArgs.vertY = jumpArgs.sprite:getY() - jumpArgs.amp
	
	-- Upward motion's data
	local upDx = jumpArgs.vertX - jumpArgs.sprite:getX()
	local upDy = jumpArgs.amp
	jumpArgs.upK = upDy / upDx ^ 2
	
	-- Downward motion's data
	local downDx = jumpArgs.x - jumpArgs.vertX
	local downDy = jumpArgs.y - jumpArgs.vertY
	jumpArgs.downK = downDy / downDx ^ 2
	
	
	-- Initial coeffecient for parabolic motion
	jumpArgs.k = jumpArgs.upK
	jumpArgs.isVertexPassed = false
	
	return jumpArgs

end

function updateParabolicJump(jumpArgs)
	
	-- First upward motion
	updateParabolicMotion(jumpArgs)
	
	-- If vertex passed change coeffecient of parabola
	-- to downward motion coeffecient.
	-- If sprite has onJumpVertexPassed, call it only once 
	if isXPointPassed(jumpArgs.vertX, jumpArgs.vel, jumpArgs.sprite:getX()) then
	
		-- Change the value of flag jumpArgs.isVertexPassed
		-- to true to call the onJumpVertexPassed function
		-- only once and to prevent assignment of vars on 
		-- enter frame 
		if not jumpArgs.isVertexPassed then
			if jumpArgs.sprite.onJumpVertexPassed then
				jumpArgs.sprite:onJumpVertexPassed()
			end
			
			jumpArgs.isVertexPassed = true
			jumpArgs.k = jumpArgs.downK
		end
		
	end
	
	-- If jump point is passed then stop motion, and set coordinates
	-- to precise coordinates. 
	-- If object has onJumpEnd method, call it
	if isXPointPassed(jumpArgs.x, jumpArgs.vel, jumpArgs.sprite:getX()) then
	
		jumpArgs.sprite:removeEventListener(Event.ENTER_FRAME, updateParabolicJump, jumpArgs)
		jumpArgs.sprite:setPosition(jumpArgs.x, jumpArgs.y)
		
		if jumpArgs.sprite.onJumpEnd then
			jumpArgs.sprite:onJumpEnd()
		end
	
	end
		
	
end



-- Returns true if point is passed on X axis
-- by object
function isXPointPassed(pointX, vel, objectX)
	if (vel > 0 and objectX > pointX)
	or (vel < 0 and objectX < pointX) then
		return true
	end
	
	return false
	
end

function updateParabolicMotion(args)
	
	local dx, dy
	-- Increase sprite's x by vel, calculate new dx
	-- dx is distance between sprite's current x
	-- and stop x
	args.sprite:setX(args.sprite:getX() + args.vel)
	dx = args.vertX - args.sprite:getX()
	
	-- Calculate change on y axis
	-- dy is new disstance between sprite and 
	-- destination point's y
	dy = args.k * dx ^ 2
	args.sprite:setY(args.vertY + dy)
	
end


