require("coord")
Object = require "lib.classic"
Plane = {}

Plane = Object:extend()

Plane.__index = Plane

function Plane:new(x_start, y_start)
  self.coord = Coord(x_start, y_start, 90)
  self.speed = 50
  self.flying = false
  self.path = {}
  self.radius = 10
end

function Plane:print()
  print(self.x)
end

function Plane:setCoords(x_set, y_set)
  self.coord.x = x_set
  self.coord.y = y_set
end

function Plane:isFlying()
  return self.flying
end

function Plane:getCoords()
  return self.x, self.y
end

function Plane:update(dt)
  --print("Path ", self.path[1], self.path[2])
  if self:isFlying() then
    if self.path[1] ~= nil then
      local dir_diff = self.coord:angleToPoint(self.path[1], self.path[2]) - self.coord.dir

      self.coord.dir = self.coord.dir + dir_diff

      if self.coord:distanceToPoint(self.path[1], self.path[2]) < 10 then
        table.remove(self.path, 1)
        table.remove(self.path, 1)
      end
      self:move(dt)
    else
      self.coord.dir = self.coord.dir + dt * 30
      self:move(dt)
      --self.flying = false
    end

  end
end

function Plane:move(dt)
  local norm = 1 / (dt * self.speed)
  local x_tmp = self.coord.x + math.cos(math.rad(self.coord.dir))/norm
  local y_tmp = self.coord.y + math.sin(math.rad(self.coord.dir))/norm
  self.coord.x = x_tmp
  self.coord.y = y_tmp
end