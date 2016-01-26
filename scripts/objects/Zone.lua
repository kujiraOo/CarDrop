Zone = {}

local zones = {

	-- WEIRD
	{
		-- улитки
		{
			objects = {"light_neon snail"},
			lim = {64, 100},
			small = 1
		}
	},

	
	-- CAMPING
	{
		-- палатки
		{
			objects = {"wigwam", "lovely wigwam", "|big_nature tent", "|big_tent"},
			lim = {130, 200},
			small = 2
		}
	},
	
	-- ORIENTAL
	{
		{
			objects = {"fire_blue fire"},
			lim = {50, 100},
			small = 1	
		}
	},
	
	-- CITY
	{
		-- шарики
		{
			objects = {"floating_balloons", "floating_heart balloon"},
			lim = {50, 90},
			small = 2
		},
		
		-- дома
		{
			objects = {"|big_city block", "|big_hamburger bar", "|big_houses", 
					   "|big_shop", --[["green house", "sunflower house"]]},
			lim = {150, 200},
			ignore_big = true
		}
	},
	
	-- HORROR
	{
		-- огни
		{
			objects = { "fire_fire of death", "floating_ghoust"},
			lim = {50, 100},
			small = 2	
		},
		
		-- грибы
		{
			objects = { "light_grebe", "light_blue mushroom"},
			lim = {10, 20},
			small = 2	
		}
	},
	

	
	
	-- FARM
	{
		-- мельницы
		{
			objects = {"|big_wheel_windmill"},
			lim = {100, 200}
		}
	}
	
}


function Zone.select()

	local dice = math.random(1, #zones[Objects.current_set])
	local zone = zones[Objects.current_set][dice]
	
	print ("выбрана зона:", dice)
	print ("количество объектов в специальной зоне:", #zone.objects)
	print ("количество специальных зон в сете:", #zones[Objects.current_set])
	
	-- для тех случаем, когда зона состоит из больших объектов и
	-- можно проигнорировать наличие деревьев
	-- или нельзя
	Zone.data = zone
	
	Zone.dice = {}
	
	for _, v1 in ipairs (zone.objects) do
		for k, v2 in ipairs (Objects_data) do
			
			if v2.name == v1 then
				table.insert(Zone.dice, k)
			end
			
		end
	end
	
	
	Objects.distancer:set_lim(zone.lim[1], zone.lim[2])
end