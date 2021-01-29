Player = Ship:extend()

function Player:new(x_start, y_start)
  Player.super.new(self, x_start, y_start, dir_start)
  self.max_speed = 550
  self.cruise_speed = 250
  self.min_speed = 50
  self.boost = 100
  self.over_boosted = false
  self.color = {1,0,0}
  self.radius = 10
  self.current_speed = 0
  self.roation_speed = 3
  self.size = 5
  self.team = Teams.blue
  self.shield_enabled = true
  self.shield_health = 100
  self.shield_recharge_rate = 5
  self.shield_max = 110
  self.equipped_weapon = Gun(10, 80)
  self.invincible = false

  self.sprite_image = sprites.player_image
end

function Player:reset()
  self.shield_health = 0
  self.current_health = 100
end

function Player:update(dt)
    Player.super.update(self, dt)
    self:updateBoost(dt)
    if outOfBounds(self.coord) then
      self:damage(dt*20)
    end

    if love.keyboard.isDown("up") and not self.over_boosted then
      self.boost = self.boost - 100*dt
      self.current_speed = self.max_speed 
    elseif love.keyboard.isDown("down") then
      self.current_speed = self.min_speed
    else 
      self.current_speed = self.cruise_speed
    end
    local rotation_speed_const = 1
    if love.keyboard.isDown("right") then
        self.coord:rotate(dt * (self.roation_speed + rotation_speed_const * (self.cruise_speed - self.current_speed) / self.cruise_speed))
    elseif love.keyboard.isDown("left") then
        self.coord:rotate(-dt * (self.roation_speed + rotation_speed_const * (self.cruise_speed - self.current_speed) / self.cruise_speed))
    end


    if self.shield_enabled then
      self.shield_health = math.min(self.shield_max, self.shield_health + self.shield_recharge_rate * dt)
    end

    

    self.coord:moveForward(self.current_speed * dt)
    self.pSystem:update(dt)
    self.pSystem:moveTo(self.coord.x, self.coord.y)

    self.pSystem:setDirection(self.coord:getT() + math.pi)
end

function Player:updateBoost(dt)
  if self.boost < 1 then
    self.over_boosted = true
  end

  -- if we need to refill
  if self.boost < 100 then
      self.boost = math.min(100, self.boost + dt * 25)
  else
    self.over_boosted = false
  end
end

function Player:damage(amount)
  -- take damage to shield first
  if self.invincible then
    return false
  end
  if self.shield_enabled then
    local shield_residual = self.shield_health - amount -- how much is left in the shield after a hit
    self.shield_health = math.max(0, shield_residual)
    if shield_residual < 0 then -- if the shield took too much damage
      self.current_health = self.current_health + shield_residual
    end
  else -- if we dont have a shield
    self.current_health = self.current_health - amount
  end

  if self.current_health <= 0 then
    return true
  else
    return false
  end
end

function Player:keypressed(key)
  if key == "space" and not love.keyboard.isDown("up") then
    self:fire()
  end

  if key == "u" then
    self.equipped_weapon:setUnlimitedAmmo(not self.equipped_weapon:getUnlimitedAmmo())
  end

  if key == "i" then
    self.invincible = not self.invincible
  end
end