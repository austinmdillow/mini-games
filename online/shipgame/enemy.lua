Enemy = Ship:extend()

function Enemy:new(x_start, y_start, dir_start)
    Enemy.super.new(self, x_start, y_start, dir_start)
    self.max_speed = 100
    self.color = {1,1,0}
    self.radius = 10
    self.current_speed = 0
    self.roation_speed = 90 * math.pi / 180 -- deg / s
    self.size = 10
    self.last_fire_time = love.timer.getTime() -- last time since a bullet was fired
    self.fire_rate = 1 -- bullets per second
    self.id = nil
    self.team = -1
    self.difficulty = 1
end

function Enemy:update(dt)
    if false then self.current_speed = self.max_speed else self.current_speed = 0 end

    if false then
        self.coord:rotate(dt * self.roation_speed)
    elseif false then
        self.coord:rotate(-dt * self.roation_speed)
    end

    if self:fire() then return "fire" end

    self:followCoord(dt, game_data.local_player.coord)
end

function Enemy:followCoord(dt, target_coord)
    local angle_error = self.coord:angleToCoord(target_coord) - self.coord:getT()
    self:rateLimitedTurn(dt, angle_error + love.math.random()* 5 * math.pi / 180)
    --print(angle_error)
    self.coord:moveForward(self.max_speed * dt)
end