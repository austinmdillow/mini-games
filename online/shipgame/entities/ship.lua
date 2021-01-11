Ship = Entity:extend()

function Ship:new(x_start, y_start)
  Ship.super.new(self, x_start, y_start, dir_start)
  self.max_speed = 100
  self.color = {1,0,0}
  self.radius = 10
  self.current_speed = 0
  self.roation_speed = 3
  self.size = 5
  self.last_fire_time = love.timer.getTime() -- last time since a bullet was fired
  self.fire_rate = 2 -- bullets per second
  self.hitbox = self.size * 3
end

function Ship:update(dt)
    self.coord:moveForward(self.current_speed * dt)
end

function Ship:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord:getT())
    love.graphics.polygon('line', self.size * -1, self.size * -1, 0, 0, self.size * -1, self.size * 1, self.size * 3, 0)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
end

function Ship:fire()
  local current_time = love.timer.getTime()
  if (current_time - self.last_fire_time) > 1 / self.fire_rate then
      self.last_fire_time = current_time
      return true
  end
  return false
end

function Ship:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Ship:keypressed(key)
  if key == " " then
    print("space is down")
  end
end

function Ship:rateLimitedTurn(dt, angle) -- the desired amount of turning
  local rotation_amount = 0
  if angle >= 0 then
    rotation_amount = math.min(dt * self.roation_speed, angle)
  else
    rotation_amount = math.max(-dt * self.roation_speed, angle)
  end
  self.coord:rotate(rotation_amount)
end

function Ship:dead()
  return self.current_health < 0
end