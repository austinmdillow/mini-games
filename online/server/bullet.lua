require "lib.mylove.coord"
Object = require "lib.mylove.classic"

Bullet = Object:extend()

function Bullet:new(x_start, y_start)
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

function Bullet:update(dt)

    self.coord:moveForward(self.current_speed * dt)

    print("Bullet location ", self.coord.x, self.coord.y)
end

function Bullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord.dir)
    love.graphics.polygon('line', self.size * -10, self.size * -10, 0, 0, self.size * -10, self.size * 10, self.size * 30, 0)
    love.graphics.circle('fill', 0, 0, 1)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
end

function Bullet:print()
  print(self.x)
end

function Bullet:getX()
	return self.coord.x
end

function Bullet:getY()
	return self.coord.y
end

function Bullet:getDir()
    return self.coord.dir
end

function Bullet:setXY(x, y)
	self.coord.x = x
	self.coord.y = y
end

function Bullet:setXYT(x, y, t)
    self:setXY(x, y)
    self.coord.dir = t
end

function Bullet:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Bullet:getColor()
	return self.color
end