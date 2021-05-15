Enemy = Ship:extend()

function Enemy:new(x_start, y_start, dir_start)
    Enemy.super.new(self, x_start, y_start, dir_start)
    self:setColor({1,1,0})

    self.max_speed = 320
    self.radius = 10
    self.current_speed = 0
    self.rotation_speed = 90 * math.pi / 180 -- deg / s
    self.size = 10
    self.team = Teams.red
    self.difficulty = 1
    self.sprite_image = nil
    self.pf_collider = HC.circle(100,100, 40)
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
    self.pf_collider:moveTo(self.coord.x, self.coord.y)
    if false then self.current_speed = self.max_speed else self.current_speed = 0 end

    if false then
        self.coord:rotate(dt * self.rotation_speed)
    elseif false then
        self.coord:rotate(-dt * self.rotation_speed)
    end

    

    self:followCoord(dt, game_data.local_player.coord)
    if self:fire() then return "fire" end
end

function Enemy:draw()
    Enemy.super.draw(self)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', self:getX(), self:getY(), 100 *self.current_health / self.max_health, 10)
    self.pf_collider:draw()
end

function Enemy:followCoord(dt, target_coord)
    local angle_error = self.coord:angleToCoord(target_coord) - self.coord:getT()
    -- TODO add this as a static function to Coord
    if angle_error > math.pi then
        angle_error = angle_error - 2 * math.pi
    elseif angle_error < -math.pi then
        angle_error = angle_error + 2 * math.pi
    end

    local lateral_force_total = 0
    for field, separating_vector in pairs(HC.collisions(self.pf_collider)) do
        local lateral_force = (separating_vector.y * math.cos(self.coord.t) - separating_vector.x * math.sin(self.coord.t))
        if lateral_force > 0 then 
            lateral_force = math.sqrt(separating_vector.x ^ 2 + separating_vector.y ^ 2)
        else
            lateral_force = -math.sqrt(separating_vector.x ^ 2 + separating_vector.y ^ 2)
        end
        lateral_force_total = lateral_force_total + lateral_force
        --print("Angle %f", self.coord.t)
        --print(separating_vector.x, separating_vector.y)
        --print("mag_lateral = %f", lateral_force)
    end

    --print(string.format("Base %.2f, mag_lat %.2f, Net %.2f",angle_error, lateral_force_total, lateral_force_total/10 + angle_error))
    self:rateLimitedTurn(dt, lateral_force_total/10 + angle_error)
    self.coord:moveForward(self.max_speed * dt)
end