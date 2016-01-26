-- объявить локальные переменные функций, чтобы можно было вызывать
-- функции в любом порядке
local objects_in_layer, trees_in_layer, objects_in_layers

local objects_touched = {}

local layer_names = {
			"front_layer2",
			"front_layer_light",
			"front_layer1",
			"rear_layer_ord",
			"rear_layer_light",
			}

function Objects.initDescription()
	stage:addEventListener(Event.TOUCHES_BEGIN, Objects.show_description)
end


function Objects.show_description(event)
	objects_touched = {}
	
	if event.touch.id ~= GUI.move_button.touch_id then
		
		-- get objects, that were touched
		objects_in_layers(event)
		
		local touched_object = objects_touched[1]
		
		for i = 1, #objects_touched do
		
			-- break the loop, because passanger has the
			-- highest touch priority
			if touched_object.id == "passanger" then
				break
			end
		
			if objects_touched[i].index > touched_object.index then
				touched_object = objects_touched[i]
			end
		end
		
		if #objects_touched > 0 then
			touched_object:onTouchAction()
		else
			GUI.object_description:setText("")
		end
		
		
	end
end





function objects_in_layers(event)
	for i = 1, #layer_names do
		objects_in_layer(layer_names[i], event)
		if #objects_touched > 0 then
			
		end
	end
			
	trees_in_layer("front_layer2", event)
	if #objects_touched > 0 then
		
	end
		
	trees_in_layer("front_layer1", event)
	if #objects_touched > 0 then
		
	end
		
	trees_in_layer("rear_layer_trees", event)
end

function objects_in_layer(layer, event)
	for i = 1, Objects[layer]:getNumChildren() do
	
		local object = Objects[layer]:getChildAt(i)
		
		if object:touched(event.touch.x, event.touch.y) then
			if object.id ~= "tree" then
				object.index = i
				table.insert(objects_touched, object)
			end
		end
	end
end

function trees_in_layer(layer, event)
	for i = 1, Objects[layer]:getNumChildren() do
	
		local object = Objects[layer]:getChildAt(i)
		
		if object:hitTestPoint(event.touch.x, event.touch.y) then
			if object.id == "tree" then
				object.index = i
				table.insert(objects_touched, object)
			end
		end
	end
end