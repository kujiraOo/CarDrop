Trees = {}


local Trees_textures = {} -- хранит в себе текстуры деревьев, система каталогов

Trees.types_quant = 0 -- хранит в себе количество типов лесов



function Trees.load_textures() 
	local trees_pack = TexturePack.new("gfx/objects/trees.txt", "gfx/objects/trees.png")
	local list = io.open("gfx/objects/trees.txt")
	
	local descrip
	local folder = 0
	
	for line in list:lines() do
		local tree_data = {}
		
		local new_folder = line:match("(.+)_")
		
		if folder ~= new_folder then
			folder = new_folder
			--print("создаю каталог текстур леса "..folder.." "..descrip)
			
			Trees_textures[folder] = {}
			Trees_textures[folder].description = folder
		end
		
		
		tree_data = trees_pack:getTextureRegion(line:match("[^,]+"))
		
		--print("добавляю в каталог", folder, descrip, line:match("/(.-)%."))
		table.insert(Trees_textures[folder], tree_data)
	end
	list:close()
	
	
	--print ("загружено "..#Trees_textures.." текстуры деревьев")
	--print ("количество видов лесов: "..Trees.types_quant)
end

function Trees.init()
	
	Trees.distancer_rear = Distancer_rnd.new(function()
		Trees.spawn("rear")
		end, 64, 128)

	
	Trees.distancer_front = Distancer_rnd.new(function()
		Trees.spawn("front")
		end, 64, 128)
		
	Trees.select()
	

end

local lims = {
	{50, 100},
	{200, 300},
	{600, 800}
}


function Trees.select()
	Trees.mode = math.random(1, 4)
	
	local local_trees = Objects.get_local_trees()
	
	Trees.forest = local_trees[math.random(#local_trees)]
	
	
	-- 1 обе стороны
	-- 2 только задняя
	-- 3 только передняя
	-- 4 ни одна
	
	--[[local lim_rear = math.random(64, 500)
	local lim_front = math.random(64, 500)
	
	-- значение второго лимита должно быть больше, чтобы
	-- работал math.random
	-- чтобы значение оставалось случайным и были близкие
	-- и маленькие расстояние между деревьями, к лимиту
	-- прибавляется рандомное число
	Trees.distancer_rear:set_lim(lim_rear, lim_rear + math.random(64, 500))
	Trees.distancer_front:set_lim(lim_front, lim_front + math.random(64, 500))]]
	
	-- выбрать плотность деревьев
	-- в начале не спавнить слишком много объектов
	local d
	
	if Game.distance < 200 then
		d = #lims
	else
		d = math.random(1, #lims)
	end
	
	Trees.distancer_rear:set_lim(lims[d][1], lims[d][2])
	Trees.distancer_front:set_lim(lims[d][1], lims[d][2])
	
	-- в зависимости от режима остановить спавн
	-- деревьев в том или ином ряду
	if Trees.mode == 1 then
		Trees.distancer_rear:start()
		Trees.distancer_front:start()
	elseif Trees.mode == 2 then
		Trees.distancer_rear:start()
		Trees.distancer_front:pause()
	elseif Trees.mode == 3 then
		Trees.distancer_rear:pause()
		Trees.distancer_front:start()
	else
		Trees.distancer_rear:pause()
		Trees.distancer_front:pause()
	end
	
	Trees.distance = Game.distance + math.random(10, 50)
	
	print ("Режим деревьев:", Trees.mode, Trees.forest, "Деревья поменяются на", Trees.distance)
end

function Trees.spawn(row)
	local tree
	local dice = math.random(#Trees_textures[Trees.forest])
	
	--print(dice)
	
	tree = Object.new()
	
	tree.id = "tree"
	tree.description = Trees_textures[Trees.forest].description
	local img = Bitmap.new(Trees_textures[Trees.forest][dice])
	img:setAnchorPoint(0.5, 1)
	tree:addChild(img)
	
	tree.width = tree:getWidth()
	tree.height = tree:getHeight()
	
	tree.x = 700
	
	tree:setX(tree.x)
	
	if row == "front" then
		if math.random() > 0.5 then
			tree.layer = "front1"
			tree:setY(295)
			Objects.front_layer1:addChild(tree)
		else 
			tree.layer = "front2"
			tree:setY(305)
			Objects.front_layer2:addChild(tree)
		end
	elseif row == "rear" then
		tree:setY(math.random(-10,0))
		tree.layer = "rear"
		tree:setY(190)
		tree:setScale(0.75, 0.75)
		Objects.rear_layer_trees:addChild(tree)
	end
	
	tree:addEventListener(Event.ENTER_FRAME, Object.on_enter_frame, tree)
end


