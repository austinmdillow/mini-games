function setupMap(m, w, layer_level)
  --m:addCustomLayer("Sprite Layer", layer_level)
  local spriteLayer = m.layers[SPRITE_LAYER]
	spriteLayer.sprites = {
    player = player
  }

  spriteLayer.items = {}
  
  -- spawn the player
  for _, obj in pairs(m.layers[PLAYER_SPAWN_LAYER].objects) do
    print(obj)
    if obj.properties["default"] == true and obj.shape == "point" then
      player:setPosition(obj.x, obj.y)
      print("set pos")
    end
  end

  -- spawn enemies
  for _, obj in pairs(m.layers[ENEMY_SPAWN_LAYER].objects) do
    print(obj)
    if obj.properties["on_start"] == true and obj.shape == "point" then
      table.insert(spriteLayer.sprites, Enemy(obj.x, obj.y, w))
      print("set pos")
    end
  end

  for _, obj in pairs(m.layers[ITEM_LAYER].objects) do
    print(obj)
    if obj.properties["on_start"] == true and obj.shape == "point" then
      table.insert(spriteLayer.items, Coin(obj.x, obj.y))
      print("set pos")
    end
  end



	-- Update callback for Custom Layer
	function spriteLayer:update(dt)
		for _, sprite in pairs(self.sprites) do
			sprite:update(dt)
    end
    for _, sprite in pairs(self.items) do
			sprite:update(dt)
    end
    camera.x = player.coord.x
    camera.y = player.coord.y
    camera.scale = 1
	end

	-- Draw callback for Custom Layer
	function spriteLayer:draw()
		for _, sprite in pairs(self.sprites) do
      sprite:draw()
    end
    for _, sprite in pairs(self.items) do
      sprite:draw()
		end
  end
  return spriteLayer.sprites
end