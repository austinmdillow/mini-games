Entity = Object:extend()
require("src.entities.weapon")
require("src.entities.axe")

function Entity:new(x_start, y_start)
  self.coord = Coord(x_start, y_start, 0)
  self.speed = 80
  self.image = sprites.player_img
  self.stats = {
    hp = 100,
    size = 100,
    strength = 10,
    food = 100,
    water = 100
  }
  self.tool = nil
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

function Entity:knockback(ix, iy)
  if self.body ~= nil then
    self.body:applyLinearImpulse(ix, iy)
  end
end

function Entity:getCoord()
  return self.coord
end

function Entity:harm(damage)
  self.stats.hp = self.stats.hp - damage
  if (self.stats.hp <= 0) then
    print(self, "has died")
    return true
  end
  return false
end