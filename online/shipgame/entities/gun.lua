Gun = Object:Extend()


function Gun:new()
  self.ammo = 0
  self.unlimited_ammo = true
  self.fire_rate = 30
  self.damage = 30
  self.cooldown_rate = nil
  self.overheated = false
  self.overheat_capable = false
end

function Gun: