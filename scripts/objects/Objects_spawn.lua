local spawn_density1, spawn_density2 


local function place_to_rear(object, spawned_from_cloud, cloud_x, cloud_y)
	if object.light then
		object.layer = "rear_light"
		Objects.rear_layer_light:addChild(object)
	else 
		object.layer = "rear_ord"
		Objects.rear_layer_ord:addChild(object)
	end
		
	if spawned_from_cloud then
		object.y = cloud_y
		object:setY(object.y)
		if object.type ~= "floating" and object.type ~= "circular" then
			object.scale_speed = 0.65 * object.speed_y / (200 - object.y)
		end
	else
		object:setScale(0.75)
		object.y = 0.75 * object.y + 200
		object:setY(object.y)
	end
end

local function place_to_front(object, spawned_from_cloud, cloud_x, cloud_y)
	if object.light then
		object.layer = "front_light"
		Objects.front_layer_light:addChild(object)
		object.front_layer_y = 300
	elseif math.random() > 0.5 then
		object.layer = "front1"
		Objects.front_layer1:addChild(object)
		object.front_layer_y = 295
	else
		object.layer = "front2"
		Objects.front_layer2:addChild(object)
		object.front_layer_y = 305
	end
		
	if spawned_from_cloud then
		object.y = cloud_y
		object:setY(object.y)
		if object.type ~= "floating" and object.type ~= "circular"	then
			object.scale_speed = 0.9 * object.speed_y / (object.front_layer_y - object.y)
		end
	else
		object.y = object.y + object.front_layer_y
		object:setY(object.y)
	end
end

function Objects.spawn(spawned_from_cloud, cloud_x, cloud_y)
	local object, dice
	
	if DEBUG_DICE then
		dice = DEBUG_DICE
		
	elseif Zone.dice then
	
		if Zone.data.ignore_big then
			dice = Zone.dice[math.random(1, #Zone.dice)]
		elseif Trees.mode == 1 then
			if Zone.data.small then
				dice = Zone.dice[math.random(1, Zone.data.small)]
			else
				dice = math.random(Objects.local_small)
			end
		else
			dice = Zone.dice[math.random(1, #Zone.dice)]
		end
		
	else

		if Trees.mode == 1 then
			dice = math.random(Objects.local_small)
		else
			dice = math.random(#Objects_data)
		end
	end
	
	--print(dice, Objects[dice].name)
	
	if Objects_data[dice].type == "wheel" then
		object = Object.wheel(dice)
		
	elseif Objects_data[dice].type == "fire" then
		object = Object.fire(dice)
		
	elseif Objects_data[dice].type == "floating" then
		object = Object.floating(dice)
		
	elseif Objects_data[dice].type == "circular" then
		object = Circular.spawn(dice)
	else
		object = Object.ordinary(dice)
	end
	
	object.light = Objects_data[dice].light
	object.big = Objects_data[dice].big
	
	object.width = object:getWidth()
	object.height = object:getHeight()
	
	if not spawned_from_cloud then
		object.x = 700 + object.width/2
	else
		object.scale = 0.1
		object:setScale(object.scale, object.scale)
		object.x = cloud_x
		object.falling = true
	end
	
	object:setX(object.x)
	
	if object.big and Trees.mode == 2 then 
		place_to_front(object, spawned_from_cloud, cloud_x, cloud_y)
	elseif object.big and Trees.mode == 3 then
		place_to_rear(object, spawned_from_cloud, cloud_x, cloud_y)
	else
		if math.random() > 0.5 then
			place_to_rear(object, spawned_from_cloud, cloud_x, cloud_y)
		else
			place_to_front(object, spawned_from_cloud, cloud_x, cloud_y)
		end
	end
	
	
	object:addEventListener(Event.ENTER_FRAME, Object.on_enter_frame, object)
end

-- таблица с разными лимитами для дистансера
local lims = {
	{10, 50},
	{200, 300},
	{500, 700}
}

function Objects.select_density()
	-- Выбор рандомного лимита
	local d 
	
	-- обычная смена плотности:
	-- зарандомить саму плотность объектов
	-- сбросить глобальную переменную Zone.dice,
	-- чтобы функция Objects.spawn работала нормально
	if math.random() > 0.1 then
		
		-- в начале игры, чтобы никого не шокировать
		-- редко спавнить объекты
		if Game.distance < 200 then
			d = #lims
		else
			d = math.random(1, #lims)
		end
		
		Objects.distancer:set_lim(lims[d][1], lims[d][2])
		Zone.dice = nil
		Zone.data = nil
		
	-- выбрать специальную зону объектов,
	-- установится плотность и таблица Zone.dice для
	-- функции Objects.spawn
	else
		print ("Выбор специальной зоны")
		Zone.select()
	end
	
	-- Если плотность объектов большая, то продлится это недолго
	if d and d == 1 then
		Objects.density_distance = Game.distance + 10
	else
		Objects.density_distance = Game.distance + math.random(50, 75) -- было 10, 50
	end
	
	print ("Режим плотность объектов теперь", d)
	print ("Плотность объектов поменяется на", Objects.density_distance)
end

function Objects.spawn_init()
	Objects.distancer = Distancer_rnd.new(Objects.spawn, 64, 128)
	Objects.select_density()
	Objects.distancer:start()
end

