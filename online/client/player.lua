require "lib.classic"
require "coord"
Object = require "lib.classic"

Player = Object:extend()

function Player:new(x_start, y_start)
  self.coord = Coord(x_start, y_start)
  self.max_speed = 100
  self.color = {1,0,0}
  self.path = {}
  self.radius = 10
  self.current_speed = 0
  self.roation_speed = 3
  self.size = 2
  self.tail_number = "N7261" .. math.floor(love.math.random(0,10))
end

function Player:update(dt)
    if love.keyboard.isDown("up") then self.current_speed = self.max_speed else self.current_speed = 0 end

    if love.keyboard.isDown("right") then
        self.coord:rotate(dt * self.roation_speed)
    elseif love.keyboard.isDown("left") then
        self.coord:rotate(-dt * self.roation_speed)
    end

    self.coord:moveForward(self.current_speed * dt)

    print("Player location ", self.coord.x, self.coord.y)
end

function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord.dir)
    love.graphics.polygon('line', self.size * -10, self.size * -10, 0, 0, self.size * -10, self.size * 10, self.size * 30, 0)
    love.graphics.circle('fill', 0, 0, 1)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
end

function Player:print()
  print(self.x)
end

function Player:getX()
	return self.coord.x
end

function Player:getY()
	return self.coord.y
end

function Player:getDir()
    return self.coord.dir
end

function Player:setXY(x, y)
	self.coord.x = x
	self.coord.y = y
end

function Player:setXYT(x, y, t)
    self:setXY(x, y)
    self.coord.dir = t
end

function Player:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Player:getColor()
	return self.color
end

function Player:keypressed(key)
  if key == " " then
    print("space is down")
  end
end