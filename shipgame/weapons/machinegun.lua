Machinegun = Gun:extend()

function Machinegun:new()
  Machinegun.super.new(self)
  self.ammo = 100
  self.max_ammo = nil
  self.unlimited_ammo = true
  self.fire_rate = 30
  self.last_fire_time = love.timer.getTime()
  self.damage = 30
  self.cooldown_rate = 29
  self.current_heat = 0
  self.max_heat = 20
  self.overheated = false
  self.overheat_capable = true
  self.label = "machinegun"
end