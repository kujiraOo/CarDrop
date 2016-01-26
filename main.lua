
Game.load()


RAIN_CHANCE = 0.1

START_MODE = 1


--Game.distance = 1000

if START_MODE == 1 then
	Game.load_data()
	Game.start()
else
	Logo.play() 
end

--[[for i = 1, #Objects_data do
	print (i, Objects_data[i].name, Objects_data[i].type)
end]]

-- после анимации вызывает Game.load_textures() и Start_screen.init()
-- Start_screen.init() по нажатию на экран вызывает Game.start()

