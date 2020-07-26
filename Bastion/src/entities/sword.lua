Sword = Weapon:extend()

function Sword:new()
  Sword.super.new(self)
  self.image = sprites.sword_image
  self.damage = 5
end

function Sword:use()
  print("sword damage", self.damage)
  return Sword.super.use(self)
end