General = {}

function General.hit(size, x1, y1, x2, y2)
	if x2 > x1 - size/2 and x2 < x1 + size/2
	and y2 > y1 - size/2 and y2 < y1 + size/2 then
		return true
	end
	return false
end

function General.square_hit(x1, y1, size1, x2, y2, size2)
	if (x2 + size2/2 > x1 - size1/2 and y2 + size2/2 > y1 - size1/2)
	or (x2 - size2/2 > x1 + size1/2 and y2 + size2/2 > y1 - size1/2)
	or (x2 - size2/2 > x1 + size1/2 and y2 - size2/2 > y1 + size1/2)
	or (x2 + size2/2 > x1 - size1/2 and y2 - size2/2 > y1 + size1/2) then
		return true
	end
	return false
end

function General.draw_rectangle(x1, x2, y1, y2, color)
	local rect = Shape.new()
	rect:setFillStyle(Shape.SOLID, color)
	rect:moveTo (x1, y1)
	rect:lineTo (x2, y1)
	rect:lineTo (x2, y2)
	rect:lineTo (x1, y2)
	rect:closePath()
	rect:endPath()
	
	return rect
end

-- взять из таблицы случайный элементы, исключая себя
function General.random_el(t, el)
	local new_el = math.random(1, #t)
	if el == new_el then
		return General.random_el(t, el)
	else
		return new_el
	end
end