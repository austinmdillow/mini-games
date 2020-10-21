Bullet = Entity:extend()

function Bullet:new(x_start, y_start, dir_start)
  Bullet.super.new(self, x_start, y_start, dir_start)

  self.rotation_visual = 0
  self.max_speed = 300
  self.size = 10
  self.color = COLORS.green
  self.team = nil
  self.source_id = nil
  self.damage = 45
end

function Bullet:update(dt)
    self.coord:moveForward(self.max_speed * dt)
    self.rotation_visual = self.rotation_visual + self.roation_speed + dt
end

function Bullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord:getT() + self.rotation_visual)
    love.graphics.rectangle('line', -1 * self.size / 2, -1 * self.size / 2, self.size, self.size)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
end

function Bullet:setColorRandom()
	self.color = {love.math.random(), love.math.random(), love.math.random()}
end

function Bullet:setTeamAndSource(team, source)
  self.team = team
  self.source = source
end