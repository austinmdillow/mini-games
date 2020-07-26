local last_spawn_time = love.timer.getTime()

function updateCommon(dt, map, world)
  spawnCharacters(dt, map, world)
  cleanupCharacters(map, world)
  cleanupItems(map)
  
end

function mousepressedCommon(x, y, button, istouch, presses)
  player.inventory:mousepressed(x, y, button)
end

function spawnCharacters(dt, map, world)
  local spriteLayer = map.layers[SPRITE_LAYER]
  for _, obj in pairs(map.layers[ENEMY_SPAWN_LAYER].objects) do
    if obj.properties["on_start"] == false and obj.shape == "point" and love.timer.getTime() - last_spawn_time > obj.properties["period"]then
      table.insert(spriteLayer.sprites, Enemy(obj.x, obj.y, world))
      last_spawn_time = love.timer.getTime()
    end
  end
end

function cleanupCharacters(map, world)
  local sprite_table = map.layers[SPRITE_LAYER].sprites
  local item_table = map.layers[SPRITE_LAYER].items
  for key, entity in pairs(sprite_table) do
    local killed = entity:garbage()
    if killed then
      table.insert(item_table, Coin(entity.coord.x, entity.coord.y))
      entity.body:destroy()
      sprite_table[key] = nil -- remove the dead character
    end
  end
end

function cleanupItems(map)
  local item_table = map.layers[SPRITE_LAYER].items
  for key, entity in pairs(item_table) do
    local killed = entity:garbage()
    if killed then
      item_table[key] = nil -- remove the dead character
    end
  end
end