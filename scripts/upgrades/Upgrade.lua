Upgrade = {}

Upgrade.change_rate = 5
Upgrade.level = 0


local function sprite_remove_id(sprite, id)
	for i = sprite:getNumChildren(), 1, -1 do
		local child = sprite:getChildAt(i)
		if child.id == id then
			sprite:removeChild(child)
		end
	end
end


local function add_new_upgrade(level)

	local upgrade

	local data = Upgrade.data[level]
	
	sprite_remove_id(Car.layer, data.id)
	
	if data.id == "wheels" then
		upgrade = Car.wheels_init(Upgrade.pack:getTextureRegion(data.txr, Car.wheels_offset), Car.wheels_offset)
		upgrade:setPosition(Car.wheels_x, Car.wheels_y)
	else
		upgrade = data.spr
		upgrade:setPosition(data.x, data.y)
	end
	
	upgrade.light = data.l
	upgrade.id = data.id
	
	if not upgrade.light then
		upgrade:setColorTransform(Filter.red, Filter.green, Filter.blue)
	end
	
	Car.layer:addChild(upgrade)


end

local function add_upgrade_on_start(level, type)
	for i = level, 1, -1 do
		if Upgrade.data[i].id == type then
			add_new_upgrade(i)
			break
		end
	end
end

function Upgrade.level_up()
	local change_incr

	Upgrade.level = Upgrade.level + 1
	--Upgrade.req = Upgrade.req + Upgrade.change_rate
	
	if Upgrade.level < 5 then
		change_incr = Upgrade.change_rate * (Upgrade.level + 1)
	else
		change_incr = Upgrade.change_rate * 5
	end
	
	Upgrade.req = Upgrade.req + change_incr
	
	add_new_upgrade(Upgrade.level)
	
	Sfx.play("fanfare")
	
	Upgrade_animation.play()
	
	Game.save()
	
	print ("Car level is", Upgrade.level)
	print ("Stars req is", Upgrade.req)
	print ("Star touched is", Star.touched_count)
end

function Upgrade.init()

	Upgrade.pack = TexturePack.new("gfx/upgrade.txt", "gfx/upgrade.png")
	
	Upgrade_animation.init()
	
	Upgrade.load_data() 
	
	Upgrade.req = 0
	
	
	for i = 1, Upgrade.level + 1 do
		print ("I IS", i)
		if i < 5 then
			Upgrade.req = Upgrade.req + Upgrade.change_rate * i
			print(Upgrade.req)
		else
			Upgrade.req = Upgrade.req + Upgrade.change_rate * 5
		end
	end
	
	

	--Upgrade.level = math.floor(Star.touched_count / Upgrade.change_rate)
	
	--Upgrade.req = Upgrade.level * Upgrade.change_rate  + Upgrade.change_rate
	
	if Upgrade.level > Upgrade.max_level then
		Upgrade.level = Upgrade.max_level
	end

	add_upgrade_on_start(Upgrade.level, "spoiler")
	add_upgrade_on_start(Upgrade.level, "other")
	add_upgrade_on_start(Upgrade.level, "wheels")
	
	print ("Car level is", Upgrade.level)
	print ("Stars req is", Upgrade.req)
	print ("Star touched is", Star.touched_count)
	
	
	if Upgrade.level > 0 then
		Upgrade_animation.play()
	end
end
