Enemy = Entity:extend()

function Enemy:new(x_start, y_start, dir_start)
    Enemy.super.new(self, x_start, y_start, dir_start)
    self.max_speed = 100
    self.color = {1,1,0}
    self.radius = 10
    self.current_speed = 0
    self.roation_speed = 3
    self.size = 10
    self.last_fire_time = love.timer.getTime() -- last time since a bullet was fired
    self.fire_rate = 2 -- bullets per second
    self.id = nil
    self.team = -1
end

function Enemy:update(dt)
    if false then self.current_speed = self.max_speed else self.current_speed = 0 end

    if false then
        self.coord:rotate(dt * self.roation_speed)
    elseif false then
        self.coord:rotate(-dt * self.roation_speed)
    end

    self.coord:moveForward(self.current_speed * dt)

    if self:fire() then return "fire" end
end

function Enemy:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord.t)
    love.graphics.polygon('line', self.size * -1, self.size * -1, 0, 0, self.size * -1, self.size * 1, self.size * 3, 0)
    love.graphics.circle('fill', 0, 0, 1)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
end

function Enemy:fire()
    local current_time = love.timer.getTime()
    if (current_time - self.last_fire_time) > 1 / self.fire_rate then
        self.last_fire_time = current_time
        return true
    end
    return false
end
