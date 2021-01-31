


function love.update()
  x, y = love.mouse.getPosition()
  print(x, y, love.math.noise(x,y))
end

function love.draw()
  love.graphics.circle('fill', 100, 100, love.math.noise(x+.1,y)*100)
end