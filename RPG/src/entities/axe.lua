Axe = Weapon:extend()

function Axe:new()
  Axe.super.new(self)
  self.image = sprites.sword_image
  self.range = 100
  self.damage = 101
  self.range = 44
  self.rate = .5
  self.sound = love.audio.newSource("assets/sounds/RPG_Sound_Pack/battle/swing.wav", "static")
end

function Axe:use()
  print("using an Axe")
  return Axe.super.use(self)
end