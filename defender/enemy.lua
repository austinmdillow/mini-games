Enemy = Object:extend()


function Enemy:new(x_start, y_start)
  self.coord = Coord(x_start,y_start,0)
  self.speed = 500   
  self.size = 10
  self.width = 150
  self.color = COLORS.periwinkle
  self.health = 10
  self.timealive = 0
  self.time2die = 60
  self.fire_rate = 0.5 --shots per second
  self.last_fire_time = love.timer.getTime()
end 

function Enemy:update(dt)
  --self.coord:moveForward(self.speed * dt)
  --self.timealive = self.timealive + dt 
  self:fire()
end 

function Enemy:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle("line", self.coord.x, self.coord.y , self.size)
end 

-- check if the enemy should be removed from gameplay
function Enemy:isDestroyed()
  if self.timealive > self.time2die then
    return true
  else
    return false
  end
end

function Enemy:fire()
if love.timer.getTime() - self.last_fire_time > 1/self.fire_rate then
  local temp_bullet = Bullet(self.coord.x, self.coord.y, -1)
  temp_bullet:setColor(COLORS.periwinkle)
  table.insert(bullet_list, temp_bullet)
  self.last_fire_time = love.timer.getTime()
end

end   
