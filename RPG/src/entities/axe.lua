Axe = Weapon:extend()

function Axe:new()
  Axe.super:new()
  self.image = sprites.sword_image
end

function Axe:use()
  return Axe.super:use()
end