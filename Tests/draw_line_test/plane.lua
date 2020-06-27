require("coord")
Plane = {}

Plane.__index = Plane

function Plane:new(x_start, y_start)
  local this = { 
    coord = Coord(x_start, y_start, 90),
    speed = 50,
    t = 0,
    flying = false,
    path = {},
    radius = 10
  }
  setmetatable(this, Plane)
  return this
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
      self.coord.dir = self.coord:angleToPoint(self.path[1], self.path[2])

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
  print("After calculation ", x_tmp, y_tmp, self.coord.dir)
  print("After calculation ", self.coord.x, self.coord.y, self.dir)
end