level_menu = {}

function level_menu:init()
end

function level_menu:enter()
end

function level_menu:update(dt)
end

function level_menu:draw()
  love.graphics.print("Level Selector", 0, 0)
end

function level_menu:keypressed(key)
  if key == "escape" then
    Gamestate.pop()
  end
end

return level_menu