Object = require "classic"

Coord = Object:extend()

function Coord:new(x, y, dir)
  self.x = x or 0
  self.y = y or 0
  self.dir = dir or 90
end

function Coord:angleToPoint(x, y)
  return math.atan2(y-self.y, x-self.x) * 180 / math.pi
end

function Coord:polarToCartesianOffset(r, theta)
  return self.x + r * math.cos(math.rad(theta)), self.y + r * math.sin(math.rad(theta))
end

function Coord:distanceToPoint(x, y)
  return math.sqrt((x - self.x)^2 + (y - self.y)^2)
end


function Coord:distanceToCoord(coord)
  return math.sqrt((coord.x - self.x)^2 + (coord.y - self.y)^2)
end