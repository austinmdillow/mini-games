

function print_table(arr, indentLevel)
	local str = ""
	local indentStr = "#"

	if(indentLevel == nil) then
			print(print_table(arr, 0))
			return
	end

	for i = 0, indentLevel do
			indentStr = indentStr.."\t"
	end

	for index,value in pairs(arr) do
			if type(value) == "table" then
					str = str..indentStr..index..": \n"..print_table(value, (indentLevel + 1))
			elseif type(value == "bool") then
					str = str..indentStr..index..": "..tostring(value).."\n"
			else 
					str = str..indentStr..index..": "..value.."\n"
			end
			print(str)
	end
	return str
end

-- draw the box_2d bodies in a given world
-- must use camera or something similar for alignment
function drawBodies(world)
	local i = 0
	for _, body in pairs(world:getBodies()) do
    for _, fixture in pairs(body:getFixtures()) do
        i = i + 1
				local shape = fixture:getShape()
 
				if shape:typeOf("CircleShape") then
						local cx, cy = body:getWorldPoints(shape:getPoint())
						love.graphics.circle("line", cx, cy, shape:getRadius())
				elseif shape:typeOf("PolygonShape") then
						love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
				else
						love.graphics.line(body:getWorldPoints(shape:getPoints()))
				end
		end
  end
  --print(i)
end


function drawDebugInfo()
  love.graphics.print('Memory actually used (in kB): ' .. collectgarbage('count'), 10,10)
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 40)
end