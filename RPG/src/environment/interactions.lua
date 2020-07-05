function getObjectAtCoord(m, layer, coord)
	local x_tile, y_tile = m:convertPixelToTile(coord.x, coord.y)

	for i, obj in pairs(m.layers[layer].objects) do 
		if obj.shape == "point" then
			if coord:distanceToPoint(obj.x, obj.y) < 30 then
				return obj
			end
		elseif obj.shape == "rectangle" then
			local box = {
				{x = obj.x, y = obj.y}, 
				{x = obj.x + obj.width, y = obj.y + obj.height}
			}
			if BoundingBox(box, coord.x, coord.y) then
				return obj
			end
		end
	end
end


function handleActions(map, entity)
  local door = getObjectAtCoord(map, "DoorLayer", entity.coord)

	if door ~= nil then
		active_selection.text = "Press enter"
		active_selection.type = "door"
    active_selection.property = door.properties["Destination"]
    local destination = door.properties["destination"]
    print(door.properties["destination"])
    if destination == "inn" then
      Gamestate.switch(inn_level)
    elseif destination == "mainWorld" then
      Gamestate.switch(mainWorld)
    end
	else
		active_selection = {}
	end
end


function displayActions(map, entity)
  local door = getObjectAtCoord(map, "DoorLayer", entity.coord)

	if door ~= nil then
		active_selection.text = "Press enter"
		active_selection.type = "door"
		active_selection.property = door.properties["Destination"]
		print(door.properties["destination"])
	else
		active_selection = {}
	end
end