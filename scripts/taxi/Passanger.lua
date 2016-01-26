--[[
		File: Passanger.lua
		-------------------
		В этом файле находятся методы  класса Passanger.
		
		Объект класса Passanger появляется в двух видах:
		1) мувиклип, когда он стоит на обочине и машет;
		2) мувиклип, когда он сидит на крыше машины
		
		В начале игры происходит инициализация passangerSpawnTimer c
		рандомной задержкой в пределах от PASSANGER_TIMER_DELAY_MIN до
		PASSANGER_TIMER_DELAY_MAX.
		
		Пассажир спавнится по таймеру в координате PASSANGER_INITIAL_X 
		в переднем или заднем слое объектов.
		
		Когда пассажир стоит на обочине, можно нажать на него,
		и он запрыгнет на машину. Если пропустить его, то как только
		он пропадет за левым краем экрана, убрать его и перезапустить
		passangerSpawnTimer с новой задержкой.
		
		Рядом с ним появится бабл, в котором будет написано до 
		какого из объектов класса TaxiObject он хочет доехать. Бабл исчезает
		по таймеру passangerBubbleTimer. Если нажать на пассажира, сидящего на
		машинке, то бабл появится опять и скроется вновь по таймеру. 
		
		Если игроку по пути встретится объект класса TaxiObject, 
		и он нажмет на него, то пассажир спрыгнет к объекту, и рядом
		с ним появится бабл с надписью "Thanks!". Игрок получит ускорение
		машинки. И плюс к счетчику подвезенных пассажиров. Перезапустится
		passangerSpawnTimer и скоро появится новый пассажир.
		
		Пассажир будет сидеть на машинке, пока игрок не тыкнет на нужный
		пассажиру объект класса TaxiObject
		

  ]]

Passanger = Core.class(Object)

-- Local methods
local placeNewPassangerToFront, placeNewPassangerToRear, spawnPassanger,
	randomizePassangerTimerDelay, createBubbleText

-- Local vars
local passangerSpawnTimer, passangerBubbleTimer, passangerTexturePack

local passangersGraphicsData = {}


-- Constants

local NUMBER_OF_PASSANGERS = 2

local PASSANGER_SIZE = 32
local PASSANGER_INITIAL_X = 400
local PASSANGER_REMOVE_X = -100
local PASSANGER_TIMER_DELAY_MIN = 1
local PASSANGER_TIMER_DELAY_MAX = 1


local PASSANGER_CAR_X = 250
local PASSANGER_CAR_Y = 212

local PASSANGER_BUBBLE_PADDING_LEFT = 8
local PASSANGER_BUBBLE_WIDTH = 54
local PASSANGER_BUBBLE_HEIGHT = 28
local PASSANGER_BUBBLE_HIDE_TIMER_DELAY = 2

local HANDS = {
	POSITION = {LEFT = {X = 9}, RIGHT = {X = 22}, Y = 13},
	ANCHOR = {X = 0, Y = 1},
	ANGLE = {-15, 15}
}



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-------------------------------------- I N I T -------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--[[
	Passanger constructor, inits passanger in specific 
	coordinate in spicific objects layer
	
	Passanger object is a Sprite object with
	random textures and hands animation, so we need to init
	graphics
]]
function Passanger:init(x, y, layerId)

	self:setPosition(x, y)
	self.layer = layerId
	
	-- Passanger has several different states
	-- to conrol passenger's behaviour
	-- "waiting" - default, waiting to get pikced up by player
	-- "jumpOn" - jumping on car
	-- "sitting" - sits on car
	-- "jumpOff" - jumps to specified object
	-- "thanking" - thanks player for the ride
	self.state = "waiting"
	
	-- for Objects.show_description function
	self.description = ""
	self.id = "passanger"
	
	-- chose passanger's destination
	self:initDestination()
	
	-- init passanger's graphics
	self:initGFX()
	
	self:addEventListener(Event.ENTER_FRAME, Passanger.move, self)
end


-- Init passanger's destination randomly.
-- This method sets passanger's field
-- destinationId to the randomly selected
-- index of TaxiObject.data table 
function Passanger:initDestination()

	
	math.random()
	math.random()
	math.random()
	math.random()

	-- Randomize TaxiObject.data table's index
	local k = math.random(1, #TaxiObject.DATA)
	
	self.destination = TaxiObject.DATA[k]
	
	return 
end


-- Init passanger's graphics
function Passanger:initGFX()
	-- create front view graphics 
	self:initFrontView()
	
	-- create side view graphics
	self:initSideView()
	
	-- create bubble with destination place
	self:initBubble()
end


--[[ 
	This method loads random graphics for a passanger.
	It choses random assets from passangersGraphicsData
	and saves table's index to self.graphicsId
	
	It creates also passanger's front and side views.
	
	Passanger's initial view is front view.
--]]
function Passanger:initFrontView()

	self.graphicsId = math.random(1, NUMBER_OF_PASSANGERS)
	
	-- create sprite to add body and hands to it
	self.frontView = Sprite.new()
	
	-- body section, create body bitmap
	local body = self:initFrontBodyBitmap()
	
	-- create hands sprite
	local hands = self:initHandsSprite()
	
	-- set y anchor point
	body:setY(-body:getWidth())
	hands:setY(-body:getWidth() + HANDS.POSITION.Y)
	
	-- add body and hands to front view sprite
	self.frontView:addChild(body)
	self.frontView:addChild(hands)
	
	-- add front view sprite to passanger's sprite
	self:addChild(self.frontView)
	
end

-- Inits body graphics, returns Bitmap
function Passanger:initFrontBodyBitmap()
	
	-- get texture from texture pack
	local bodyTexture = TaxiTexturePack:getTextureRegion("passanger_" .. self.graphicsId .. "_front.png")
	local bodyBitmap = Bitmap.new(bodyTexture)
	
	return bodyBitmap
	
end


-- Inits hands' graphics and animation, returns Sprite
function Passanger:initHandsSprite()

	local handsSprite = Sprite.new()
	
	-- get texture from texture region
	local handTexture = TaxiTexturePack:getTextureRegion(
							"passanger_" .. self.graphicsId .. "_hand.png")
	
	local rightHandBitmap = Bitmap.new(handTexture)
	local leftHandBitmap = Bitmap.new(handTexture)

	
	-- animate left and right hands
	local rightHandAnimation = Animations.waveMotion(rightHandBitmap, 
										HANDS.ANCHOR.X, HANDS.ANCHOR.Y, 
										HANDS.ANGLE[1], HANDS.ANGLE[2])
														
	local leftHandAnimation = Animations.waveMotion(rightHandBitmap, 
										HANDS.ANCHOR.X, HANDS.ANCHOR.Y, 
										HANDS.ANGLE[1], HANDS.ANGLE[2])
	leftHandAnimation:setScaleX(-1)
	
	-- set position and add to handsSprite
	rightHandAnimation:setX(HANDS.POSITION.RIGHT.X)
	leftHandAnimation:setX(HANDS.POSITION.LEFT.X)
									
	handsSprite:addChild(rightHandAnimation)
	handsSprite:addChild(leftHandAnimation)
	
	return handsSprite
end


-- Inits passanger's side view bitmap
function Passanger:initSideView()
	local bodyTexture = TaxiTexturePack:getTextureRegion("passanger_" .. self.graphicsId .. "_side.png")
	self.sideView = Bitmap.new(bodyTexture)
	self.sideView:setAnchorPoint(0, 1)
end


-- Init passanger's bubble with destinition point
function Passanger:initBubble()
	local bubbleTexture = TaxiTexturePack:getTextureRegion("bubble.png")
	self.bubble = Bitmap.new(bubbleTexture)
	
	self.bubble:setAnchorPoint(0, 1)
	-- Position at right top corner
	self.bubble:setPosition(self:getWidth(), -self:getHeight())
	
	self:initBubbleText()
	
	self:initBubbleHideTimer()
	
	self:addChild(self.bubble)
end


function Passanger:initBubbleText()

	-- Get text from TaxiObject.data, add text to bubble
	local text = self.destination.ID
	local bubbleTextField = TextField.new(GUI.font, text)
	
	-- Position in bubble's center
	bubbleTextField:setPosition(PASSANGER_BUBBLE_PADDING_LEFT + 
								PASSANGER_BUBBLE_WIDTH/2 - bubbleTextField:getWidth()/2,
								-PASSANGER_BUBBLE_HEIGHT/2)
	
	-- Set text's color to destination's text color
	bubbleTextField:setTextColor(self.destination.TEXT_COLOR)
	
	self.bubble:addChild(bubbleTextField)
end



function Passanger:initBubbleHideTimer()
	self.bubbleHideTimer = EnterFrameTimer.new(
		function () self.bubble:setVisible(false) end,
		PASSANGER_BUBBLE_HIDE_TIMER_DELAY)
		
	self.bubbleHideTimer:pause()
end







------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--------------------------------------- M O V E-------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--[[
	Moves passanger from right to left.
	Speed of the movement depends on the 
	speed of the Car and on the passanger' layer.
	
	If passanger leaves the screen on the left, 
	remove him from stage. And reset the passanger 
	timer.	
--]]
function Passanger:move()

	-- Move passanger
	if self.layer == "front1" then
		self:setX(self:getX() - 1.5 * Car.speed)
	else
		self:setX(self:getX() - 0.5 * Car.speed)
	end
	

	-- Remove passanger from stage and restart passanger's timer
	if self:getX() < PASSANGER_REMOVE_X - self:getWidth()/2 then
		self:removeFromStage()
		
		local delay = randomizePassangerTimerDelay()
		passangerSpawnTimer:restart(delay)
	end
	
end

-- Remove passanger from stage
function Passanger:removeFromStage()
	self:removeEventListener(Event.ENTER_FRAME, Passanger.move, self)
	self:getParent():removeChild(self)
	self = nil
end

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------- T O U C H ------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


-- If passanger is objects layer

-- Function for Objects_desctiption.lua file
function Passanger:touched(touchX, touchY)
	return self.frontView:hitTestPoint(touchX, touchY)
end


-- Passanger's on touch action. 
--
-- If passenger is waiting to get picked up 
-- by player
-- Remove on enter frame executon of move method,
-- then jump on car.
function Passanger:onTouchAction()
	
	self:removeEventListener(Event.ENTER_FRAME, Passanger.move, self)
	
	self:jumpOnCar()

end


--[[ 
	If Passanger is touched, he jumps on the car. 
	
	Jump is parabolic movement from any passanger's
	location to car's roof. 
--]]
function Passanger:jumpOnCar()

	self.bubble:setVisible(false)

	local PASSANGER_JUMP_AMP = 100
	local PASSANGER_JUMP_VEL = 5
	
	-- Prepare args table to pass it to jump
	local jumpArgs = {
		sprite = self,
		x = PASSANGER_CAR_X,
		y = PASSANGER_CAR_Y,
		amp = PASSANGER_JUMP_AMP,
		vel = PASSANGER_JUMP_VEL,
	}
	
	Animations.parabolicJump(jumpArgs)
	
end

-- When jump's vertex is passed change passanger's sprite
function Passanger:onJumpVertexPassed()
	--self:removeChild(self.frontView)
	--self:addChild(self.sideView)
end

-- Change passanger's state to sitting, 
-- add passanger's sprite to car's layer
function Passanger:onJumpEnd()
	self.state = "sitting"
	
	-- Change graphics to side view
	self:removeChild(self.frontView)
	self:addChild(self.sideView)
	
	-- Show bubble and resime bubble's hide timer
	self.bubble:setVisible(true)
	self.bubbleHideTimer:resume()
	
	-- Add touch listener
	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchSitting, self)
	
	Car.layer:addChild(self)
	self:setPosition(Car.layer:globalToLocal(PASSANGER_CAR_X, PASSANGER_CAR_Y))
	self:setColorTransform(Filter.red, Filter.green, Filter.blue)
end




-- If passanger is in car layer

-- If passanger sits on car show bubble and
-- restart bubble's hide timer
function Passanger:onTouchSitting(event)
	if self.sideView:hitTestPoint(event.touch.x, event.touch.y) then
		self.bubble:setVisible(true)
		self.bubbleHideTimer:restart()
	end
end



						-------------------------------------
						------ PUBLIC STATIC METHODS --------
						-------------------------------------

-- Load global texture pack
function Passanger.loadTaxiTexturePack()
	
	TaxiTexturePack = TexturePack.new("gfx/taxi.txt", "gfx/taxi.png")
	
end



function Passanger.initSpawnTimer()

	local delay = randomizePassangerTimerDelay()
	
	passangerSpawnTimer = EnterFrameTimer.new(spawnPassanger, delay)
	
end

	
	
						-------------------------------------
						------ PRIVATE STATIC METHODS --------
						-------------------------------------	





-- Randomize new delay for passanger's timer
function randomizePassangerTimerDelay()
	
	return math.random(PASSANGER_TIMER_DELAY_MIN, PASSANGER_TIMER_DELAY_MAX)
	
end


-- Create a passanger and randomly place it to front or rear layer
function spawnPassanger()
	
	if math.random() > 0.5 then
		placeNewPassangerToRear()
	else
		placeNewPassangerToFront()
	end

end



-- Creates new passanger and places it to objects rear layer
function placeNewPassangerToRear()

	local passanger = Passanger.new(PASSANGER_INITIAL_X, 200, "rear_ord")
	
	Objects.rear_layer_ord:addChild(passanger)

end



-- Creates new passanger and places it to the objects front layer
function placeNewPassangerToFront()

	local passanger = Passanger.new(PASSANGER_INITIAL_X, 295, "front1")
	
	Objects.front_layer1:addChild(passanger)

end

