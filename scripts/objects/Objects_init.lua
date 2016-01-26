math.randomseed(os.time())

Objects = {}
Objects.touched = 0


Objects.rear_layer = Sprite.new()

Objects.rear_layer_trees = Sprite.new()
Objects.rear_layer_light = Sprite.new()
Objects.rear_layer_ord = Sprite.new()
Objects.rear_layer:addChild(Objects.rear_layer_trees)
Objects.rear_layer:addChild(Objects.rear_layer_light)
Objects.rear_layer:addChild(Objects.rear_layer_ord)


Objects.front_layer = Sprite.new()

Objects.front_layer1 = Sprite.new()
Objects.front_layer_light = Sprite.new()
Objects.front_layer2 = Sprite.new()
Objects.circular_escape_layer = Sprite.new()

Objects.front_layer:addChild(Objects.front_layer1)
Objects.front_layer:addChild(Objects.front_layer_light)
Objects.front_layer:addChild(Objects.front_layer2)
Objects.front_layer:addChild(Objects.circular_escape_layer)

-- значение по умолчанию 250
local change_rate = 250


local objects_sets = {
	{name = "weird"   , trees = {"blooming forest", "bush"}},
	{name = "camping" ,	trees = {"crab forest", "small cactus"}},
	{name = "oriental", trees = {"apple forest", "pastel forest", "tropical palm forest"}},
	{name = "city"    , trees = {"LA cactus", "Xmas forest", "cloud forest", "palm forest"}},
	{name = "horror"  , trees = {"horror forest", "juniper forest", "spruce forest", "young spruce forest"}},
	{name = "farm"    , trees = {"beet", "cactus forest", "plum forest", "sunflowers"}},
	}
	


function Objects.set_change_rate(rate)
	change_rate = rate
end



function Objects.init_local(pack_txt, pack_png)
	-- Сначала убрать предыдущие локальные объекты
	Objects_data = {}
	
	Objects.local_big = 0
	Objects.local_small = 0
	
	

	Objects.local_pack = TexturePack.new(pack_txt, pack_png, true)
	
	local list = io.open(pack_txt)
	
	for line in list:lines() do
		-- пропустить не больше одной строчки
		local object_data = {}
		
		object_data.name = line:match("[^.]+")
		
		if line:match("light_") then
			object_data.light = true
		end
		
		if line:match("|big_") then
			object_data.big = true
			Objects.local_big = Objects.local_big + 1
		end
		
		if line:match("circular_") then
			object_data.type = "circular"
			object_data.light = true
			
		elseif line:match("floating_") then
			object_data.type = "floating"
			
		elseif line:match("wheel_") then
			if not line:match('_a') then
				line = list:read()
			else
				list:read()
			end
		
			object_data.name = object_data.name:match("(.+)_")
				
			object_data.type = "wheel"
			
			object_data.wheel_y = tonumber(line:match("|(%d+)"))
			
			Objects.local_big = Objects.local_big + 1
			
		elseif line:match("fire_") then
			
			if not line:match('_a') then
				line = list:read()
			else
				list:read()
			end
		
			object_data.name = object_data.name:match("(.+)_")
			
			object_data.type = "fire"
			object_data.light = true
			
			object_data.fire_data = {}
			object_data.code = line:match("|(%d+)")
			
			for v in line:match("|(%d+)"):gmatch("%d") do
				table.insert(object_data.fire_data, tonumber(v))
			end
			
		else
			object_data.type = "ordinary"
		end
		
		table.insert(Objects_data, object_data)
	end
	
	list:close()
	
	Objects.local_small = #Objects_data - Objects.local_big
	
	
	collectgarbage()
	collectgarbage()
	collectgarbage()
	collectgarbage()
	--print("Texture memory used: "..application:getTextureMemoryUsage())
	
	--print("Загружено "..Objects.local_big.." больших объектов и "..Objects.local_small.." маленьких")
end


	
function Objects.get_local_trees()
	return objects_sets[Objects.current_set].trees
end

local function init_objects_set(set_num)
	print ("Changing local objects to "..objects_sets[set_num].name:upper().." objects")

	Objects.init_local("gfx/objects/"..objects_sets[set_num].name..".txt", "gfx/objects/"..objects_sets[set_num].name..".png")
	Objects.current_set = set_num
end


function Objects.change_local_objects()
	-- если показали еще не все сеты, то загружается
	-- следующий по порядку через фиксированную 
	-- дистанцию change_rate
	if Game.distance < change_rate * #objects_sets then
		Objects.next_distance = Objects.next_distance + change_rate
		Objects.current_set = Objects.current_set + 1 
		
	-- в противном случае генерируется рандомная дистанция 
	-- и выибирается рандомный сет
	else 
		Objects.next_distance = Objects.next_distance + math.random(change_rate /2 , change_rate * 2)
		Objects.current_set = math.random(1, #objects_sets)
	end
	
	-- всегда загружается нужный сет
	-- сменяются деревья
	-- и сохраняется игра
	init_objects_set(Objects.current_set)
	Trees.select()
	Game.save()
	
	print ("Объекты поменяются на "..Objects.next_distance)
end

function Objects.init_starting_local_objects()

	-- если дистанция меньше 500, то загрузить первый сет 
	-- локальный объектов
	if Game.distance < change_rate  then
		init_objects_set(1)
		
		Objects.next_distance = change_rate
		
	-- вычислить исходя из дистанции текущий сет
	-- расчитать следующую дистанцию смены объектов
	-- загрузить нужныео объекты
	elseif Game.distance < change_rate * #objects_sets then
	
		local set = math.floor(Game.distance /change_rate) + 1
		
		Objects.next_distance = set * change_rate
		
		init_objects_set(set)
	
		
	-- иначе текущий сет сохраняется и загружается
	-- из файла, на всякий случай генерируется случайный сет, если он
	-- до этого не сохранился в файл 
	-- СМОТРЕТЬ функции Objects.change_local_objects и Game.save
	else
		
		math.random(1,6)
		math.random(1,6)
		math.random(1,6)
		
		local set = Game.current_set or math.random(1,6)
		
		init_objects_set(set)
		Objects.next_distance = Game.next_distance or Game.distance  + math.random(change_rate/2, change_rate*2) --math.random(150, 700)
		
	end
	
	print ("Объекты поменяются на "..Objects.next_distance)
end
