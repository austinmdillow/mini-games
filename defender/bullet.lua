Bullet = Object:extend()


function Bullet:new(x_start, y_start)
  self.coord = Coord(x_start,y_start,0)
  self.speed = 500   
  self.thickness = 2
  self.width = 150
  self.color = COLORS.aqua
  self.timealive = 0
  self.time2die = 1
end 

function Bullet:update(dt)
  self.coord:moveForward(self.speed * dt)
  self.timealive = self.timealive + dt 
end 

function Bullet:draw()
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", self.coord.x - self.thickness / 2, self.coord.y - self.thickness / 2, self.width * (1 - self.timealive), self.thickness)

end 

-- check if the bullet should be removed from gameplay
function Bullet:isDestroyed()
  if self.timealive > self.time2die then
    return true
  else
    return false
  end
end