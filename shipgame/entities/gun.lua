Gun = Object:extend()


function Gun:new()
  self.ammo = 100
  self.max_ammo = nil
  self.unlimited_ammo = true
  self.fire_rate = 10
  self.last_fire_time = love.timer.getTime()
  self.damage = 30
  self.cooldown_rate = 2
  self.current_heat = 0
  self.max_heat = 10
  self.overheated = false
  self.overheat_capable = false
  
end

function Gun:fire()
  if love.timer.getTime() - self.last_fire_time > (1 / self.fire_rate) then
    
    print(self.ammo, self.current_heat)
    if self.ammo > 0 or self.unlimited_ammo then -- if we have ammo
      if not self:getOverheat() then -- if the gun isn't overheated
        self.current_heat = self.current_heat + 1
        if self.unlimited_ammo == true then
          self.ammo = self.ammo - 1
        end
        self.last_fire_time = love.timer.getTime()
        return true
      end
    end
  end
end

function Gun:getOverheat()
  return self.overheated, self.current_heat / self.max_heat
end

function Gun:update(dt)
  self:updateOverheat(dt)
end

function Gun:updateOverheat(dt)
  self.current_heat = math.max(self.current_heat - dt * self.cooldown_rate, 0)
  if self.current_heat >= self.max_heat then
    self.overheated = true
  end

  if self.overheated and self.current_heat == 0 then
    self.overheated = false
  end
end

function Gun:getAmmo()
  return self.ammo
end