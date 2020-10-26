Enemy = Ship:extend()

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