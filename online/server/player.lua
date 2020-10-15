require "lib.classic"
require "coord"
Object = require "lib.classic"

Player = Object:extend()

function Player:new(x_start, y_start)
  self.coord = Coord(x_start, y_start, 0)
  self.speed = 30
  self.color = {1,0,0}
  self.path = {}
  self.radius = 10
  self.tail_number = "N7261" .. math.floor(love.math.random(0,10))
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

function Player:setXY(x, y)
	self.coord.x = x
	self.coord.y = y
end

function Player:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Player:getColor()
	return self.color
end