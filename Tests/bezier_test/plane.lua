Plane = { speed = 50}

Plane.__index = Plane

function Plane:new(x_start, y_start)
  local this = { 
    x = x_start, 
    y = y_start, 
    t = 0,
    curve = 3
  }
  setmetatable(this, Plane)
  return this
end

function Plane:print()
  print(self.x)
end

function Plane:setCoords(x_set, y_set)
  self.x = x_set
  self.y = y_set
end

function Plane:getCoords()
  return self.x, self.y
end

function Plane:update(dt)
  self.t = self.t + dt
end