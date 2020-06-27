Object = require "lib.classic"

Coord = Object:extend()

function Coord:new(x, y, dir)
  self.x = x or 0
  self.y = y or 0
  self.dir = dir or 90
end

function Coord:angleToPoint(x, y)
  return math.atan2(y-self.y, x-self.x) * 180 / math.pi
end

function Coord:distanceToPoint(x, y)
  return math.sqrt((x - self.x)^2 + (y - self.y)^2)
end