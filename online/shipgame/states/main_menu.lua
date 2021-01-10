main_menu = {}

function main_menu:enter()

end

function main_menu:update(dt)

end


function main_menu:draw()
  love.graphics.print(love.timer.getTime(), 100, 50)

end

return main_menu