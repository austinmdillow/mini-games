Weapon = Object:extend()

function Weapon:new()
  self.attack = 50
  self.rate = 1.5 -- swings per second
  self.durability = math.random(150-10, 150 + 10)
  self.condition = self.durability
  self.range = 32
  self.last_use = 0

end

function Weapon:use()
  if love.timer.getTime() - self.last_use > 1 / self.rate then
    self.last_use = love.timer.getTime()
    self.condition = self.condition - 1
    return self.attack, self.range
  end
end

