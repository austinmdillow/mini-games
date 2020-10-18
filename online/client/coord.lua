Object = require "lib.classic"

Coord = Object:extend()

function Coord:new(x, y, dir)
      if x == nil or y == nil then
        error("invalid x, y for Coord setup")
      end
      self.x = x or 0
      self.y = y or 0
      self.dir = dir or math.pi / 2
      print("init coord", self.x)
end

function Coord:angleToPoint(x, y)
    return math.atan2(y-self.y, x-self.x) * 180 / math.pi
end

function Coord:polarToCartesianOffset(r, theta)
    return self.x + r * math.cos(theta), self.y + r * math.sin(theta)
end

function Coord:distanceToPoint(x, y)
    return math.sqrt((x - self.x)^2 + (y - self.y)^2)
end


function Coord:distanceToCoord(coord)
    return math.sqrt((coord.x - self.x)^2 + (coord.y - self.y)^2)
end

function Coord:moveAlongDir(dist)
    return self.x + dist * math.cos(self.dir), self.y + dist * math.sin(self.dir)
end

function Coord:moveForward(dist)
    self.x = self.x + dist * math.cos(self.dir)
    self.y = self.y + dist * math.sin(self.dir)
end

-- positive rotation is clockwise
function Coord:rotate(rotation)
    self.dir = self.dir + rotation
end

function Coord:setXY(new_x, new_y)
    self.x = new_x
    self.y = new_y
end

function Coord:normalVectorToCoord(coord)
  local x_vec = coord.x - self.x
  local y_vec = coord.y - self.y
  local magnitude = math.sqrt(x_vec ^ 2 + y_vec ^ 2)
  return x_vec / magnitude, y_vec / magnitude
end