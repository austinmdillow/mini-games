Enemy = Object:extend()


function Enemy:new(x_start, y_start, dir_start)
    self.coord = Coord(x_start, y_start, dir_start)
    self.max_speed = 100
    self.color = {1,1,0}
    self.current_health = 10
    self.max_health = 1
    self.path = {}
    self.radius = 10
    self.current_speed = 0
    self.roation_speed = 3
    self.size = 2
    self.last_fire_time = love.timer.getTime() -- last time since a bullet was fired
    self.fire_rate = 2 -- bullets per second
end

function Enemy:update(dt)
    if false then self.current_speed = self.max_speed else self.current_speed = 0 end

    if false then
        self.coord:rotate(dt * self.roation_speed)
    elseif false then
        self.coord:rotate(-dt * self.roation_speed)
    end

    self.coord:moveForward(self.current_speed * dt)

    -- print("Enemy location ", self.coord.x, self.coord.y)
    if self:fire() then return "fire" end
end

function Enemy:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord.dir)
    love.graphics.polygon('line', self.size * -10, self.size * -10, 0, 0, self.size * -10, self.size * 10, self.size * 30, 0)
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


function Enemy:print()
  print(self.x)
end

function Enemy:getX()
	return self.coord.x
end

function Enemy:getY()
	return self.coord.y
end

function Enemy:getXY()
    return self.coord.x, self.coord.y
end

function Enemy:getDir()
    return self.coord.dir
end

function Enemy:setXY(x, y)
	self.coord.x = x
	self.coord.y = y
end

function Enemy:setXYT(x, y, t)
    self:setXY(x, y)
    self.coord.dir = t
end

function Enemy:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Enemy:getColor()
	return self.color
end