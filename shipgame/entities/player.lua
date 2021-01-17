Player = Ship:extend()

function Player:new(x_start, y_start)
  Player.super.new(self, x_start, y_start, dir_start)
  self.max_speed = 250
  self.cruise_speed = 150
  self.min_speed = 50
  self.color = {1,0,0}
  self.radius = 10
  self.current_speed = 0
  self.roation_speed = 3
  self.size = 5
  self.team = 0
  self.shield_enabled = true
  self.shield_health = 100
  self.shield_recharge_rate = 5
  self.shield_max = 110
  self.equipped_weapon = Gun()
  self.partimg=love.graphics.newImage("assets/particle.png")
  self.pSystem = love.graphics.newParticleSystem(self.partimg, 40)
  self.pSystem:setParticleLifetime(3, 4) -- Particles live at least 2s and at most 5s.
	self.pSystem:setEmissionRate(10)
  self.pSystem:setSizeVariation(1)
  self.pSystem:setSizes(3)
  self.pSystem:setSpeed(100,100)
  self.pSystem:setSpin(1,1)
  self.pSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.
end

function Player:reset()
  self.shield_health = 0
  self.current_health = 100
end

function Player:update(dt)
    if love.keyboard.isDown("up") then 
      self.current_speed = self.max_speed 
    elseif love.keyboard.isDown("down") then
      self.current_speed = self.min_speed
    else 
      self.current_speed = self.cruise_speed
    end

    if love.keyboard.isDown("right") then
        self.coord:rotate(dt * (self.roation_speed + (self.cruise_speed - self.current_speed) / 150))
    elseif love.keyboard.isDown("left") then
        self.coord:rotate(-dt * (self.roation_speed + (self.cruise_speed - self.current_speed) / 150))
    end

    self.coord:moveForward(self.current_speed * dt)
    
    if self.shield_enabled then
      self.shield_health = math.min(self.shield_max, self.shield_health + self.shield_recharge_rate * dt)
    end

    self.equipped_weapon:update(dt)
    self.pSystem:update(dt)
    self.pSystem:moveTo(self.coord.x, self.coord.y)

    self.pSystem:setDirection(self.coord:getT() + math.pi)
end

function Player:damage(amount)
  -- take damage to shield first
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

function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.push()
    love.graphics.translate(self.coord.x, self.coord.y)
    love.graphics.rotate(self.coord:getT())
    love.graphics.polygon('line', self.size * -1, self.size * -1, 0, 0, self.size * -1, self.size * 1, self.size * 3, 0)
    love.graphics.circle('fill', -5, 0, 4 * self.current_speed / self.max_speed)

    love.graphics.pop()
    love.graphics.draw(self.pSystem, 0,0)
    love.graphics.setColor(1,1,1)
end

function Player:keypressed(key)
  if key == "space" and not love.keyboard.isDown("up") then
    if self.equipped_weapon:fire() then
      local tmp_bullet = Bullet(game_data.local_player.coord)
      tmp_bullet:setTeamAndSource(game_data.local_player.team, game_data.local_player)
      table.insert(game_data.bullet_list, tmp_bullet)
    end
  end

  if key == "u" then
    self.equipped_weapon:setUnlimitedAmmo(not self.equipped_weapon:getUnlimitedAmmo())
  end
end