Entity = Object:extend()
require("src.entities.weapon")
require("src.entities.axe")
require("src.entities.sword")

function Entity:new(x_start, y_start)
  self.coord = Coord(x_start, y_start, 0)
  self.speed = 80
  self.image = sprites.player_img
  self.stats = {
    hp = 100,
    hp_max = 100,
    size = 100,
    strength = 10,
    food = 100,
    water = 100,
    xp = 10,
  }
  self.tool = nil
  self.isGarbage = false
  self.isDead = false
end

function Entity:draw()
  if self.image ~= nil then
    love.graphics.draw(self.image, self.coord.x - self.image:getWidth()/2, self.coord.y - self.image:getWidth()/2, self.r)
  else
    love.graphics.circle('line', self.coord.x, self.coord.y, 10)
  end
end

function Entity:update(dt)
  if self.isDead == true then
    self.isGarbage = true
  end
end

function Entity:knockback(ix, iy)
  if self.body ~= nil then
    self.body:applyLinearImpulse(ix, iy)
  end
end

function Entity:getCoord()
  return self.coord
end

function Entity:die()
  print(self, "has died")
  self.isDead = true
end

function Entity:garbage()
  return self.isGarbage
end

function Entity:harm(damage)
  self.stats.hp = self.stats.hp - damage
  if (self.stats.hp <= 0) then
    self:die()
    return true
  end
  return false
end

function Entity:drawHealth(x_offset, y_offset)
  local bar_width = 50
  love.graphics.setColor(COLORS.red)
  love.graphics.rectangle('fill', self.coord.x - bar_width / 2, self.coord.y - y_offset, self.stats.hp / self.stats.hp_max * bar_width, 5)
end