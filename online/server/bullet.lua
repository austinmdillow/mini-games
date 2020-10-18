require "lib.mylove.coord"
Object = require "lib.mylove.classic"

Bullet = Object:extend()

function Bullet:new(x_start, y_start, dir_start)
  if type(x_start) == "table" then
    if x_start:is(Coord) then
      self.coord = Coord(x_start.x, x_start.y, x_start.dir)
    end
  else
    self.coord = Coord(x_start, y_start, dir_start)
  end
  print("TYPE", type(x_start))
  
  print(x_start, y_start, dir_start)
  self.max_speed = 300
  self.color = {0,1,0}
  self.current_speed = self.max_speed
  self.roation_speed = 3
  self.rotation_visual = 0
  self.size = 5
end

function Bullet:update(dt)

    self.coord:moveForward(self.current_speed * dt)
    self.rotation_visual =  self.rotation_visual + self.roation_speed + dt

    print("Bullet location ", self.coord.x, self.coord.y)
end

function Bullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord.dir + self.rotation_visual)
    love.graphics.rectangle('line', -1 * self.size / 2, -1 * self.size / 2, self.size, self.size)
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