Entity = Object:extend()

function Entity:new(x_start, y_start)
  self.coord = Coord(x_start, y_start, 0)
  self.speed = 100
  self.image = sprites.player_img
end

function Entity:draw()
  if self.image ~= nil then
    love.graphics.draw(self.image, self.coord.x - self.image:getWidth()/2, self.coord.y - self.image:getWidth()/2, self.r)
  else
    love.graphics.circle('line', self.coord.x, self.coord.y, 10)
  end
end

function Entity:update(dt)
end