main_menu = {}

function main_menu:enter()

end

function main_menu:update(dt)

  if love.keyboard.isDown("p") then
    Gamestate.switch(gameplay)
  end

end


function main_menu:draw()
  love.graphics.print(love.timer.getTime(), 100, 50)

end

return main_menu