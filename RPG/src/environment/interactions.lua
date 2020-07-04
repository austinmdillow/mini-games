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

function setupMap(m, layer_level)
  m:addCustomLayer("Sprite Layer", layer_level)
  local spriteLayer = m.layers["Sprite Layer"]
	spriteLayer.sprites = {
    player = player
  }
  print("Inside setup map")
  
  for _, obj in pairs(m.layers[PLAYER_SPAWN_LAYER].objects) do
    print(obj)
    if obj.properties["default"] == true and obj.shape == "point" then
      player:setPosition(obj.x, obj.y)
      print("set pos")
    end
  end

  for _, obj in pairs(m.layers[ENEMY_SPAWN_LAYER].objects) do
    print(obj)
    if obj.properties["on_start"] == true and obj.shape == "point" then
      table.insert(spriteLayer.sprites, Entity(obj.x, obj.y))
      print("set pos")
    end
  end



	-- Update callback for Custom Layer
	function spriteLayer:update(dt)
		for _, sprite in pairs(self.sprites) do
			sprite:update(dt)
			camera.x = sprite.coord.x
			camera.y = sprite.coord.y
		end
	end

	-- Draw callback for Custom Layer
	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
      sprite:draw()
		end
	end
end