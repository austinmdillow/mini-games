local List = require("list")

list = List:new(20, 40, 300, 450)

function love.load()
  list:add("hi", 1, "infooo")
  list:done()
end

function love.update()
  list:update(dt)
  list.x = love.math.random(0,100)
end

function love.draw()
  list:draw()
end